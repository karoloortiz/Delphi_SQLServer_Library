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

unit KLib.SQLServer.Info;

interface

uses
  KLib.Types;

const
  DEFAULT_SQLSERVER_PORT = 1433;

type
  TSQLServerCredentials = record
  private
    _port: integer;
    function _get_port: integer;
    procedure _set_port(value: integer);
  public
    credentials: TCredentials;
    server: string;
    database: string;
    property port: integer read _get_port write _set_port;
    procedure clear;
  end;

implementation

procedure TSQLServerCredentials.clear;
const
  EMPTY: TSQLServerCredentials = ();
begin
  Self := EMPTY;
end;

function TSQLServerCredentials._get_port: integer;
var
  _result: integer;
begin
  if _port = 0 then
  begin
    _result := DEFAULT_SQLSERVER_PORT;
  end
  else
  begin
    _result := _port;
  end;

  Result := _result;
end;

procedure TSQLServerCredentials._set_port(value: integer);
begin
  _port := value;
end;

end.
