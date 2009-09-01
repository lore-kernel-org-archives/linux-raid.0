From: Anil Raj <anil.calvin@gmail.com>
Subject: Re: NEWBIE Q: expanding hardware RAID
Date: Tue, 1 Sep 2009 17:14:48 -0400
Message-ID: <714cf35c0909011414q1f081266u47f194431fcf3176@mail.gmail.com>
References: <714cf35c0908311753q1b7b26d8r2c148d566ea6fdeb@mail.gmail.com>
	 <C6C20E3B.CB5A%david@santools.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C6C20E3B.CB5A%david@santools.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi David,
 Thank you very much for you detailed and patient response.

 My RAID controller is PERC 5/E and the external Dell drives are setup
up in RAID5. (I installed Dell's OpenManage Server Administration
which gave me the details of my existing RAID). Here's some output
(that might be useful):

$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: DELL     Model: MD1000           Rev: A.00
  Type:   Enclosure                        ANSI SCSI revision: 05
Host: scsi0 Channel: 02 Id: 00 Lun: 00
  Vendor: DELL     Model: PERC 5/E Adapter Rev: 1.00
  Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 06 Lun: 00
  Vendor: PE/PV    Model: 1x2 SCSI BP      Rev: 1.0
  Type:   Processor                        ANSI SCSI revision: 02
Host: scsi1 Channel: 01 Id: 00 Lun: 00
  Vendor: MegaRAID Model: LD 0 RAID1   34G Rev: 521X
  Type:   Direct-Access                    ANSI SCSI revision: 02

I also updated the controller's ancient firmware and drivers (though
these will take effect only after a reboot).

 Once all users on my system have backed-up their data, I will be able
to do a reboot and any further maintenance (which hopefully should be
soon). (This was my only reason for not being able to do a reboot
yet.)

 However, after reading through all the documentation on the Server
Administration software and the controller manuals, I'm still unsure
if expanding a hardware RAID is possible (and if so, how to perhaps do
it). (Some parts of the manuals seem to indicate that simply
installing the additional HDs is enough; the raid controller (during
reboot) will automatically detect the new drives and expand the RAID -
not sure if I've interpreted this correctly or not).

Any tips at all would be very helpful!

Thanks
Best
Anil

On Tue, Sep 1, 2009 at 12:33 AM, David Lethe<david@santools.com> wrote:
> The answer to #2 is a function of the make/model of hardware RAID, an=
d the
> configuration. =A0 Sorry. =A0While there are standards for what RAID-=
5 means,
> there is no built-in universal program that will configure all RAID
> subsystems.
>
> Dell supports several RAID controllers.
>
> The answer to #1 is also, unfortunately a function of the make/model =
of
> RAID. =A0You can enter cat /proc/scsi/scsi and see if PERC, or DELL o=
r LSI
> shows up in the vendor field. =A0If so, highly probable it is RAID, b=
ut that
> won't tell you if it is RAID0, 1, 10, 5, etc... =A0 If there are entr=
ies in
> /dev/mpt, then it is a LSI-based RAID controller. (But not necessaril=
y in a
> hardware protected RAID mode)
>
> If it says PERC or LSI, it is definitely a RAID config, but the confi=
g could
> be set up so you see individual disk drives, or it could be a n-DISK =
RAID5
> that is partitioned into individual disks.
>
> If it is hardware RAID, then I suggest, based solely on the newbie qu=
estions
> that you find the documentation and read a bit, and run whatever soft=
ware
> that comes with it to assess the situation. =A0 =A0Expanding a hardwa=
re RAIDset,
> can be dangerous, especially if you are unfamiliar with it.
>
> For example, maybe the firmware is ancient, or you have a lot of bad =
blocks
> because you never fixed them, or even knew about running consistency/=
repairs
> . If you don't know what you are doing, then you can easily lose ever=
ything.
>
> So FIRST thing I would do before so much as powering off is a full ba=
ckup.
> If you don't know what you have, then obviously you can't properly ma=
intain
> it. =A0(Not trying to put you down, but if you aren't willing or able=
 to
> examine the configuration while it is powered on, and you don't want =
to do a
> reboot indicates the system may be unstable, or is mission critical a=
nd has
> no maintenance window, or you just don't know how to bring it back up
> properly. =A0If any of those are the case, back up before something f=
ails.
>
> Remember disk drives have a 100% probability of failure ... Eventuall=
y. =A0You
> just don't want it to happen while you are responsible for the system=
=2E
>
>
> P.S. Did you just try the simple thing of logging onto Dell's support=
 site
> and entering the service tag and get the configuration that they orig=
inally
> shipped?
>
>
>
> On 8/31/09 7:53 PM, "Anil Raj" <anil.calvin@gmail.com> wrote:
>
>> current RAID setup to include
>> the new drives. Is there any documentation on expanding hardware RAI=
D?
>> ( I found doc on growing software RAID on the mailing list's wiki bu=
t
>> none on hardware RAID.)
>>
>> I really really hope someone can help me with these questions, pleas=
e.
>> Also, if this is not the right forum (and there is a more relevant
>> forum) for these questions, please do let
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
