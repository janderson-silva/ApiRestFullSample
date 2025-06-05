unit interfaces.auth;

interface

uses
  System.JSON;

type
  iAuth = interface
    function CreateToken(out Erro : String) : TJSONObject; overload;
  end;


implementation

end.
