From: CoolCold <coolthecold@gmail.com>
Subject: Re: RAID10 performance with 20 drives
Date: Mon, 5 Jun 2017 16:52:27 +0700
Message-ID: <CAGqmV7rX7H_sTuJ7RBVHZX+TCTcWAH0K32CimD0oeEB_r32AyQ@mail.gmail.com>
References: <CAGqmV7p4_r+ca+Wq_UXcY4RDa7WwE2nWkgXF+Sn3ChwLEmkurQ@mail.gmail.com>
 <20170531191441.40240b7f@natsu> <CAGqmV7qB=8a_peu2gsU9Xne6v4nymT-O+vhDwkwaUJhyYpkieg@mail.gmail.com>
 <20170601063318.GJ24459@reaktio.net> <CAAMCDecqU+adgyg5pLokVgZ+Dh32a5Cezaaqygps16zqzM7j1Q@mail.gmail.com>
 <CAMNNMLEuutwLE8xft+ZEo=ShxRP=rJEq1kzNtVbgE5RBTOYcrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMNNMLEuutwLE8xft+ZEo=ShxRP=rJEq1kzNtVbgE5RBTOYcrQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nikhil Kshirsagar <nkshirsa@redhat.com>
Cc: Roger Heflin <rogerheflin@gmail.com>, =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>, Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello!
The data i was able to find with lsscsi:
Enclosure:
[0:0:24:0]   enclosu LSI      SAS3x40          0601  -
  state=3Drunning queue_depth=3D254 scsi_level=3D6 type=3D13 device_blocked=
=3D0 timeout=3D0

Server https://www.supermicro.com/products/system/2u/2028/ssg-2028r-e1cr24l=
.cfm

Drives are:
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Vendor:               TOSHIBA
Product:              AL14SEB18EQ
Revision:             0101
User Capacity:        1,800,360,124,416 bytes [1.80 TB]
Logical block size:   512 bytes
Physical block size:  4096 bytes
Lowest aligned LBA:   0
Rotation Rate:        10500 rpm
Form Factor:          2.5 inches
Logical Unit id:      0x500003975840f759
Serial number:        X6K0A0D5FZRC
Device type:          disk
Transport protocol:   SAS
Local Time is:        Mon Jun  5 09:51:56 2017 UTC
SMART support is:     Available - device has SMART capability.
SMART support is:     Enabled
Temperature Warning:  Enabled

(don't think it matters though)

On Thu, Jun 1, 2017 at 6:31 PM, Nikhil Kshirsagar <nkshirsa@redhat.com> wro=
te:
> Did you check max_sectors_kb ? We found once, in some setups with raid, i=
n
> particular with HP raid controllers, larger number of drives seemed to
> reduce the value of max_sectors_kb. Sorry if its already mentioned, I
> haven't read the entire thread in detail.
>
> On Thu, Jun 1, 2017 at 4:50 PM, Roger Heflin <rogerheflin@gmail.com> wrot=
e:
>>
>> Also supply an "iostat -x 1 5" since that will show each disks usage.
>>
>> vmstat in my experience does not appear to show internal MD disk traffic=
.
>>
>> On Thu, Jun 1, 2017 at 1:33 AM, Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi>=
 wrote:
>> > On Thu, Jun 01, 2017 at 12:59:01PM +0700, CoolCold wrote:
>> >> Hello!
>> >> Roman, i've updated the kernel to 4.11 and started "check" action,
>> >> results are basically the same, output on github
>> >> https://gist.github.com/CoolCold/663de7c006490d7fd0ac7cc98b7a6844
>> >> 1 cpu is overloaded, not more than 1.3 - 1.4GB/sec
>> >>
>> >
>> > You need to provide more details about the actual storage setup.
>> >
>> > Like already said/asked for:
>> >
>> > - Which HBA are you using?
>> > - Which PCIe link speed are you using for the HBA?
>> > - Which driver version for the HBA?
>> > - Which HBA firmware version?
>> >
>> > - How are the disks connected to the HBA ? Direct-connect, or via an
>> > Expander?
>> > - If you have an expander, what's the (SAS) link speed/count between t=
he
>> > HBA(s) and the Expander?
>> >
>> >
>> > -- Pasi
>> >
>> >> On Wed, May 31, 2017 at 9:14 PM, Roman Mamedov <rm@romanrm.net> wrote=
:
>> >> > On Wed, 31 May 2017 19:20:10 +0700
>> >> > CoolCold <coolthecold@gmail.com> wrote:
>> >> >
>> >> >> Creation (disable write intent bitmap, with bitmap all is much
>> >> >> worse):
>> >> >> mdadm --create -c 64 -b none -n 20 -l 10 /dev/md1 /dev/sde /dev/sd=
f
>> >> >> /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm
>> >> >> /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt
>> >> >> /dev/sdu /dev/sdv /dev/sdw /dev/sdx
>> >> >>
>> >> >> kernel:
>> >> >> [root@spare-a17484327407661 rovchinnikov]# cat /proc/version
>> >> >> Linux version 3.10.0-327.el7.x86_64
>> >> >> (builder@kbuilder.dev.centos.org)
>> >> >> (gcc version 4.8.3 20140911 (Red Hat 4.8.3-9) (GCC) ) #1 SMP Thu N=
ov
>> >> >> 19 22:10:57 UTC 2015
>> >> >>
>> >> >> So, the question is - why cpu usage is so high and I suppose is a
>> >> >> limit here?
>> >> >
>> >> > Definitely try a newer kernel, 4.4 at the very least; if no changes
>> >> > then 4.11.
>> >> >
>> >> > Also I would suggest to try out larger chunk sizes, such as 512 and
>> >> > 1024 KB.
>> >> >
>> >> > If you plan to use this long-term in production, also read up on th=
e
>> >> > various
>> >> > RAID10 data layouts and their benefits and downsides (man md, searc=
h
>> >> > for
>> >> > "layout"; and search the Internet for benchmarks of all three).
>> >> >
>> >> > --
>> >> > With respect,
>> >> > Roman
>> >>
>> >>
>> >>
>> >> --
>> >> Best regards,
>> >> [COOLCOLD-RIPN]
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-raid"
>> >> in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



--=20
Best regards,
[COOLCOLD-RIPN]
