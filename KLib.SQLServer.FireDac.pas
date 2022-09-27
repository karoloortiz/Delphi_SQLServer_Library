{
  KLib Version = 3.0
  The Clear BSD License

  Copyright (c) 2020 by Karol De Nery Ortiz LLave. All rights reserved.
  zitrokarol@gmail.com

  Redistribution and use in source and binary forms, with or without
  modification, are permitted (subject to the limitations in the disclaimer
  below) provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

  * Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

  NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY
  THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
  CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
  IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE.
}

unit KLib.SQLServer.FireDac;

interface

uses
  KLib.SQLServer.Info,
  FireDAC.Comp.Client;

type

  T_Query = class(FireDAC.Comp.Client.TFDQuery)
  end;

  T_Connection = class(FireDAC.Comp.Client.TFDConnection)
  private
    function getPort: integer;
    procedure setport(value: integer);
  public
    property port: integer read getPort write setPort;
  end;

function _getSQLServerTConnection(SQLServerCredentials: TSQLServerCredentials): T_Connection;

function getValidSQLServerTFDConnection(SQLServerCredentials: TSQLServerCredentials): TFDConnection;
function getSQLServerTFDConnection(SQLServerCredentials: TSQLServerCredentials): TFDConnection;

implementation

uses
  KLib.SQLServer.Validate,
  Klib.Utils,
  FireDAC.VCLUI.Wait,
  FireDAC.Stan.Def, FireDAC.Stan.Async,
  FireDac.DApt,
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  System.SysUtils;

const
  PORT_DELIMITER_SERVER_PARAM = ', ';

function T_Connection.getPort: integer;
var
  port: integer;
  _serverParam: string;
  _onlyServerString: string;
  _portAsString: string;
begin
  _serverParam := TFDPhysMSSQLConnectionDefParams(ResultConnectionDef.Params).Server;
  splitStrings(_serverParam, PORT_DELIMITER_SERVER_PARAM, _onlyServerString, _portAsString);
  if _portAsString = '' then
  begin
    port := DEFAULT_SQLSERVER_PORT;
  end
  else
  begin
    port := StrToInt(_portAsString);
  end;

  Result := port;
end;

procedure T_Connection.setPort(value: integer);
var
  _modifiedServerParam: string;
  _modifiedPortAsString: string;
  _serverParam: string;
  _onlyServerString: string;
  _portAsString: string;
begin
  _serverParam := TFDPhysMSSQLConnectionDefParams(ResultConnectionDef.Params).Server;
  splitStrings(_serverParam, PORT_DELIMITER_SERVER_PARAM, _onlyServerString, _portAsString);
  _modifiedPortAsString := IntToStr(value);
  _modifiedServerParam := _onlyServerString + PORT_DELIMITER_SERVER_PARAM + _modifiedPortAsString;

  TFDPhysMSSQLConnectionDefParams(ResultConnectionDef.Params).Server := _modifiedServerParam;
end;

function _getSQLServerTConnection(SQLServerCredentials: TSQLServerCredentials): T_Connection;
var
  _FDConnection: TFDConnection;
  connection: T_Connection;
begin
  _FDConnection := getSQLServerTFDConnection(SQLServerCredentials);
  connection := T_Connection(_FDConnection);
  Result := connection;
end;

function getValidSQLServerTFDConnection(SQLServerCredentials: TSQLServerCredentials): TFDConnection;
var
  connection: TFDConnection;
begin
  validateSQLServerCredentials(SQLServerCredentials);
  connection := getSQLServerTFDConnection(SQLServerCredentials);
  Result := connection;
end;

function getSQLServerTFDConnection(SQLServerCredentials: TSQLServerCredentials): TFDConnection;
var
  connection: TFDConnection;
begin
  validateRequiredSQLServerProperties(SQLServerCredentials);
  connection := TFDConnection.Create(nil);
  with connection do
  begin
    LoginPrompt := false;

    DriverName := 'MSSQL';
    with Params do
    begin
      with SQLServerCredentials do
      begin
        Values['server'] := server + PORT_DELIMITER_SERVER_PARAM + IntToStr(port);
        Values['User_Name'] := credentials.username;
        Values['Password'] := credentials.password;
        Values['Database'] := database;
      end;
    end;
  end;
  Result := connection;
end;

end.
