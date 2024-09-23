unit Posix.Ifaddrs;

interface

uses Posix.SysSocket;

type
  Pifaddrs = ^Ifaddrs;

  Ifaddrs = record
    ifa_next: Pifaddrs;
    ifa_name: MarshaledAString;
    ifa_flags: Cardinal;
    ifa_addr: Psockaddr;
    ifa_netmask: Psockaddr;

    ifa_ifu: record
      case Cardinal of
        0:
          (ifu_broadaddr: Psockaddr);
        1:
          (ifu_dstaddr: Psockaddr);
    end;

    ifa_data: Pointer;
  end;

function getifaddrs(out Pointer: Pifaddrs): Integer;
procedure freeifaddrs(Pointer: Pifaddrs);

implementation

function getifaddrs; external 'libc.so';
procedure freeifaddrs; external 'libc.so';

end.
