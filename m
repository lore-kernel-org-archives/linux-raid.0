From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Re: Advice requested
Date: Mon, 2 Nov 2015 22:28:33 -0600
Message-ID: <CAPpdf5-DMFrKRiBXjstJkvqQU1KzqJoL=hfNVqTGjy2HfMcALQ@mail.gmail.com>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
	<56367C33.6060703@turmel.org>
	<CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
	<5637842D.1070000@turmel.org>
	<CAPpdf59MFX1oVwLC-bmQBaQp9K_9-+h0v64OGMnV1-k=eCzO0w@mail.gmail.com>
	<5637BCE4.8000006@turmel.org>
	<CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>
	<5637FBAC.8000900@turmel.org>
	<CAPpdf59mkRiyNYF1dT6Xp9tcofTU8hOdih+tz+i=wPJfRQrTnQ@mail.gmail.com>
	<56380690.5030600@turmel.org>
	<CAPpdf5-HbrFESY_zhfkZ4=2CtYjgO4bA4LmA+1AHkT+Gv9iY2w@mail.gmail.com>
	<56381406.7070608@turmel.org>
	<CAPpdf59EV2TfpHUiZghAfWW6qy5je686Hg_qAs4xLchrUa=G7w@mail.gmail.com>
	<5638336E.4030400@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5638336E.4030400@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Nov 2, 2015 at 10:09 PM, Phil Turmel <philip@turmel.org> wrote:
> On 11/02/2015 11:03 PM, o1bigtenor wrote:
>> On Mon, Nov 2, 2015 at 7:55 PM, Phil Turmel <philip@turmel.org> wrot=
e:
>
>>> > Woo hoo!  There's your ext4 superblock.
>>> >
>>> > Use "gdisk /dev/md0" and create a partition starting at sector 20=
48 and
>>> > occupying the rest of the array.  After you save that, you may ne=
ed
>>> > "partprobe /dev/md0" to rescan it.
>
> I specifically recommended gdisk because it works very much like fdis=
k,
> but for gpt instead of dos.  I don't ever use parted or gparted, so I
> can't help you there.
>
> Try:
>
> man gdisk
>
> ;-)
>
> You might need "apt-get install gdisk" first.

Sorry - - - meant

gdisk

then ???????

Looking at:
root@debianbase:/# gdisk /dev/md0
GPT fdisk (gdisk) version 1.0.0

Partition table scan:
 MBR: protective
 BSD: not present
 APM: not present
 GPT: present

=46ound valid GPT with protective MBR; using GPT.

Command (? for help): r

Recovery/transformation command (? for help): ?
b       use backup GPT header (rebuilding main)
c       load backup partition table from disk (rebuilding main)
d       use main GPT header (rebuilding backup)
e       load main partition table from disk (rebuilding backup)
f       load MBR and build fresh GPT from it
g       convert GPT into MBR and exit
h       make hybrid MBR
i       show detailed information on a partition
l       load partition data from a backup file
m       return to main menu
o       print protective MBR data
p       print the partition table
q       quit without saving changes
t       transform BSD disklabel partition
v       verify disk
w       write table to disk and exit
x       extra functionality (experts only)
?       print this menu

Recovery/transformation command (? for help): q
root@debianbase:/# gdisk /dev/md0
GPT fdisk (gdisk) version 1.0.0

Partition table scan:
 MBR: protective
 BSD: not present
 APM: not present
 GPT: present

=46ound valid GPT with protective MBR; using GPT.

Command (? for help): x

Expert command (? for help): ?
a       set attributes
c       change partition GUID
d       display the sector alignment value
e       relocate backup data structures to the end of the disk
g       change disk GUID
h       recompute CHS values in protective/hybrid MBR
i       show detailed information on a partition
l       set the sector alignment value
m       return to main menu
n       create a new protective MBR
o       print protective MBR data
p       print the partition table
q       quit without saving changes
r       recovery and transformation options (experts only)
s       resize partition table
t       transpose two partition table entries
u       replicate partition table on new device
v       verify disk
w       write table to disk and exit
z       zap (destroy) GPT data structures and exit
?       print this menu

doesn't really give me anything that seems even close to:

create a partition starting at sector 2048

the man page really isn't clearer - - -

n      Create a new partition. This command is modelled after the
equivalent fdisk option, although some differences exist. You enter a
partition number, starting sector, and an ending sector. Both start
and end sectors
             can be specified in absolute terms as sector numbers or
as positions measured in kibibytes (K), mebibytes (M), gibibytes (G),
tebibytes (T), or pebibytes (P); for instance, 40M specifies a
position 40MiB from the
             start  of  the disk. You can specify locations relative
to the start or end of the specified default range by preceding the
number by a '+' or '-' symbol, as in +2G to specify a point 2GiB after
the default start
             sector, or -200M to specify a point 200MiB before the
last available sector. Pressing the Enter key with no input specifies
the default value, which is the start of the largest available block
for the start  sec=E2=80=90
             tor and the end of the same block for the end sector.


so I just do ?

gdisk

n 1 2048 1923518592

Will that change any of the data on the sectors?

Please - - - is there any way of getting specific commands?

Dee
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
