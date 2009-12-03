From: CoolCold <coolthecold@gmail.com>
Subject: Re: /etc/cron.weekly/99-raid-check
Date: Thu, 3 Dec 2009 12:11:29 +0300
Message-ID: <f19d625d0912030111t6fa5ab9ep8e3c2dd14e99ad9b@mail.gmail.com>
References: <lfarkas@lfarkas.org>
	 <200912021538.nB2FcgM8003851@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200912021538.nB2FcgM8003851@wind.enjellic.com>
Sender: linux-raid-owner@vger.kernel.org
To: greg@enjellic.com
Cc: Farkas Levente <lfarkas@lfarkas.org>, CentOS mailing list <centos@centos.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 2, 2009 at 6:38 PM,  <greg@enjellic.com> wrote:
> On Nov 30, =A02:08pm, Farkas Levente wrote:
> } Subject: /etc/cron.weekly/99-raid-check
>
>> hi,
>
> Hi Farkas, hope your day is going well. =A0Just thought I would respo=
nd
> for the edification of others who are troubled by this issue.
>
>> it's been a few weeks since rhel/centos 5.4 released and there were =
many
>> discussion about this new "feature" the weekly raid partition check.
>> we've got a lot's of server with raid1 system and i already try to
>> configure them not to send these messages, but i'm not able ie. i
>> already add to the SKIP_DEVS all of my swap partitions (since i read=
 it
>> on linux-kernel list that there can be mismatch_cnt even though i st=
ill
>> not understand why?). but even the data partitions (ie. all of my
>> servers all raid1 partitions) produce this error (ie. ther mismatch_=
cnt
>> is never 0 at the weekend). and this cause all of my raid1 partition=
s
>> are rebuild during the weekend. and i don't like it:-(
>> so my questions:
>> - is it a real bug in the raid1 system?
>> - is it a real bug in my disk which runs raid (not really believe si=
nce
>> it's dozens of servers)?
>> - the /etc/cron.weekly/99-raid-check is wrong in rhel/centos-5.4?
>> or what's the problem?
>> can someone enlighten me?
>
> Its a combination of what I would consider a misfeature with what MAY
> BE, and I stress MAY be a sentient bug someplace.
>
> The current RAID/IO stack does not 'pin' pages which are destined to
> be written out to disk. =A0As a result the contents of the pages may
> change as the request to do I/O against these pages transits the I/O
> stack down to disk.

Can you write a bit more about  "the pages may change"? 'Who' can
change page contents ?


> This results in a 'race' condition where one side of a RAID1 mirror
> gets one version ofdata written to it while the other side of the
> mirror gets a different piece of data written to it. =A0In the case o=
f a
> swap partition this appears to be harmless. =A0In the case of
> filesystems there seems to be a general assurance that this occurs
> only in uninhabited portions of the filesystem.
>
> The 'check' feature of the MD system which the 99-raid-check uses
> reads the underlying physical devices of a composite RAID device. =A0=
The
> mismatch_cnt is elevated if the contents of mirrored sectors are not
> identical.
>
> The results of the intersection of all this are problematic now that
> major distributions have included this raid-check feature. =A0There a=
re
> probably hundreds if not thousands of systems which are reporting wha=
t
> may or may not be false positives with respect to data corruption.
>
> The current RAID stack has an option to 'repair' a RAID set which has
> mismatches. =A0Unfortunately there is no intelligence in this facilit=
y
> and it randomly picks one of the sectors as being 'good' and uses tha=
t
> to replace the contents of the other sector. =A0I'm somewhat reticent=
 to
> recommend the use of this facility given the issues at hand.
>
> A complicating factor is that the kernel does not report the location
> of where the mismatches occur. =A0There appears to be movement underw=
ay
> to include support in the kernel for printing out the sector location=
s
> of the mismatches.
>
> When that feature becomes available there will be a need to have some
> type of tool, in the case of RAID1 devices backing filesystems, to
> make an assessment of which version of the data is 'correct' so the
> faulty version can be over-written with the correct version.
>
> =A0 =A0 =A0 =A0As an aside what is really needed is a tool which asse=
sses
> =A0 =A0 =A0 =A0whether or not the mismatched sectors are actually in =
an
> =A0 =A0 =A0 =A0inhabited portion of the filesystem. =A0If not the 're=
pair'
> =A0 =A0 =A0 =A0facility on RAID1 could be presumably run with no issu=
es.
> =A0 =A0 =A0 =A0Given the appropriate coherency/validation checks to m=
ake sure
> =A0 =A0 =A0 =A0the sectors are still incoherent secondary to a race w=
here the
> =A0 =A0 =A0 =A0uninhabited portion chooses to become inhabited.
>
> We see the issue over a large range of production systems running
> standard RHEL5 kernels all the way up to recent versions of Fedora.
> Interestingly the mismatch counts are always an exact multiple of 128
> on all the systems.
>
> We have also isolated the problem to be RAID1 and independent of the
> backing store. =A0We run geographical mirrors where an initiator is f=
ed
> from two separate data-centers where each mirror half is based on a
> RAID5 Linux target. =A0On RAID1 mirrors which are mismatched the two
> separate RAID5 backing volumes both report completely consistent
> volumes.
>
> So there is the situation as I believe it currently stands.
>
> The notion of running the 'check' sync_action is well founded. =A0The
> issue of 'silent' data corruption is well understood and well founded=
=2E
> The Linux RAID system as of a couple of years ago will re-write any
> sectors which come up as unreadable during the check process. =A0Disk
> drives will re-allocate a sector from their re-mapping pool
> effectively replacing the bad sector. =A0This pays huge dividends wit=
h
> respect to maintaining healthy RAID farms.
>
> Unfortunately the report of the mismatch_cnt's is problematic given
> the above issues. =A0I think it is unfortunate the vendors opted to
> release this checking/reporting while these issues are still unresolv=
ed.
>
>> thanks in advance.
>> regards.
>>
>> --
>> =A0 Levente =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 "Si vis pacem para bellum!"
>
> Hope the above information is helpful for everyone running into this
> issue.
>
> Best wishes for a productive remainder of the week to everyone.
>
> Greg
>
> }-- End of excerpt from Farkas Levente
>
> As always,
> Dr. G.W. Wettstein, Ph.D. =A0 Enjellic Systems Development, LLC.
> 4206 N. 19th Ave. =A0 =A0 =A0 =A0 =A0 Specializing in information inf=
ra-structure
> Fargo, ND =A058102 =A0 =A0 =A0 =A0 =A0 =A0development.
> PH: 701-281-1686
> FAX: 701-281-3949 =A0 =A0 =A0 =A0 =A0 EMAIL: greg@enjellic.com
> ---------------------------------------------------------------------=
---------
> "Experience is something you don't get until just after you need it."
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-- Oli=
vier
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
