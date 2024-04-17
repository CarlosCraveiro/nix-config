let
  coveiro = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINUJcBtNoOMjoZABUixupQC4CIxoLn/Ej2VqA09qP6HU";
  users = [ coveiro ];

  roxanne = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEVgTdobsm43g/C2iNjKRwB+UjgIzfXj0VGMbb8s8orZ";
  systems = [ roxanne ];
in
{
  "casa_dollars5g.age".publicKeys = [ coveiro roxanne ];
  "nusp.age".publicKeys = users ++ systems;
  "susp.age".publicKeys = users ++ systems;
  "celular_dollars.age".publicKeys = users ++ systems;
  "casa_bia.age".publicKeys = users ++ systems;
  "casa_fael5g.age".publicKeys = users ++ systems;
  "casa_jade5g.age".publicKeys = users ++ systems;
  "vonbraunsanca.age".publicKeys = users ++ systems;
  "casa_fortal.age".publicKeys = users ++ systems;
  "casa_talma.age".publicKeys = users ++ systems;
  "jade_rioclaro.age".publicKeys = users ++ systems;
}
