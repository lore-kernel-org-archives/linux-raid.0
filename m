From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spare disk could not sleep / standby
Date: Mon, 7 Mar 2005 23:14:11 -0500
Message-ID: <200503080414.j284EG510309@www.watkins-home.com>
References: <422D327D.11718.F8DB3@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <422D327D.11718.F8DB3@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: 'Peter Evertz' <leo2@pec.homeip.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have no idea, but...

Is the disk IO reads or writes.  If writes, scary!!!!  Maybe data destined
for the array goes to the spare sometimes.  I hope not.  I feel safe with my
2.4 kernel.  :)

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Peter Evertz
Sent: Monday, March 07, 2005 11:05 PM
To: linux-raid@vger.kernel.org
Subject: Spare disk could not sleep / standby

I have 2 Raid5 arrays on a hpt375. Each has a (unused) spare disk. 
With change from 2.4 to 2.6 I can not put the spare disk to sleep or  

standby. 
It wakes up after some seconds. 
/proc/diskstat shows activities every 2 to 5 seconds. 
It is a problem of the plain kernel driver ( not application ) 
because 
if i raidhotremove the drives it can sleep/standby and no activities 
are 
shown in /proc/diskstats. 
If the whole Array is unmounted, there are no activities an all 
drives. 
It seems that access to md always causes an access at the spare disk 
?! 

Any hints ? Anyone with the same problem ? 

Regards 
Peter Evertz  

(Sorry: If this is a dup.)

Linux pec6 2.6.8-24.11-default #1 Fri Jan 14 13:01:26 UTC 2005 i686 
i686  
i386 GNU/Linux  

Output of ver_linux:  

Gnu C                  3.3.4 
Gnu make               3.80 
binutils               2.15.91.0.2 
util-linux             2.12c 
mount                  2.12c 
module-init-tools      3.1-pre5 
e2fsprogs              1.35 
jfsutils               1.1.7 
reiserfsprogs          3.6.18 
reiser4progs           line 
xfsprogs               2.6.13 
PPP                    2.4.2 
isdn4k-utils           3.5 
nfs-utils              1.0.6 
Linux C Library        x  1 root root 1359489 Oct  2 02:30  
/lib/tls/libc.so.6 
Dynamic linker (ldd)   2.3.3 
Linux C++ Library      5.0.7 
Procps                 3.2.3 
Net-tools              1.60 
Kbd                    1.12 
Sh-utils               5.2.1 
Modules Loaded         speedstep_lib freq_table thermal processor fan 
button  
battery ac nvram nfsd exportfs pppoe pppox ipt_TOS ip6t_LOG 
ip6t_limit  
ipt_LOG ipt_limit ipt_TCPMSS ipt_MASQUERADE usbserial ipt_pkttype 
parport_pc  
lp parport eeprom w83781d i2c_sensor i2c_i801 af_packet ppp_generic  
ip6t_state ip6_conntrack ipt_state ip6t_REJECT ipt_REJECT 
iptable_mangle  
iptable_filter ip6table_mangle ip_nat_ftp iptable_nat 
ip_conntrack_ftp  
ip_conntrack ip_tables ip6table_filter ip6_tables ipv6 hisax 
crc_ccitt isdn  
slhc edd usbhid skystar2 dvb_core i2c_core ohci_hcd evdev joydev sg 
st  
sr_mod ide_cd cdrom ehci_hcd uhci_hcd intel_agp agpgart hw_random 
dm_mod  
natsemi usbcore bcm5700 raid5 xor ext3 jbd sd_mod scsi_mod  

proc/version: 
Linux version 2.6.8-24.11-default (geeko@buildhost) (gcc version 
3.3.4 (pre  
3.3.5 20040809)) #1 Fri Jan 14 13:01:26 UTC 2005  


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

