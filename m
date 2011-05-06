From: David Brown <david@westcontrol.com>
Subject: Re: mdadm raid1 read performance
Date: Fri, 06 May 2011 09:29:59 +0200
Message-ID: <iq07vk$m0m$1@dough.gmane.org>
References: <BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>	<4DC0F2B6.9050708@fnarfbargle.com>	<BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>	<BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>	<20110505094538.0cef02cc@notabene.brown>	<BANLkTi=W=DNdqOBiGwbu67P1EgoEqNy+sg@mail.gmail.com>	<BANLkTimNxTnf2xW8hbEWK2iA6axqjnjT+A@mail.gmail.com>	<BANLkTi=2WCfoXTtyRzpBN06ph6HCsy_ShQ@mail.gmail.com>	<BANLkTinoK0fhm-a7QAu5UdJNhbRO+mv2Jw@mail.gmail.com>	<iptjde$92f$1@dough.gmane.org>	<20110505104156.GA11441@www2.open-std.org>	<ipu25h$s1b$1@dough.gmane.org> <BANLkTi=x3kC+66JKUkEAPrPBC3aH+ZB_Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=x3kC+66JKUkEAPrPBC3aH+ZB_Xg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/05/2011 06:14, CoolCold wrote:
> On Thu, May 5, 2011 at 3:38 PM, David Brown<david@westcontrol.com>
> wrote:
>> On 05/05/2011 12:41, Keld J=F8rn Simonsen wrote:
>>>
>>> On Thu, May 05, 2011 at 09:26:45AM +0200, David Brown wrote:
>>>>
>>>> On 05/05/2011 02:40, Liam Kurmos wrote:
>>>>>
>>>>> Cheers Roberto,
>>>>>
>>>>> I've got the gist of the far layout from looking at
>>>>> wikipedia. There is some clever stuff going on that i had
>>>>> never considered. i'm going for f2 for my system drive.
>>>>>
>>>>> Liam
>>>>>
>>>>
>>>> For general use, raid10,f2 is often the best choice.  The only
>>>> disadvantage is if you have applications that make a lot of
>>>> synchronised writes, as writes take longer (everything must be
>>>> written twice, and because the data is spread out there is more
>>>> head movement).  For most writes this doesn't matter - the OS
>>>> caches the writes, and the app continues on its way, so the
>>>> writes are done when the disks are not otherwise used.  But if
>>>> you have synchronous writes, so that the app will wait for the
>>>> write to complete, it will be slower (compared to raid10,n2 or
>>>> raid10,o2).
>>>
>>> Yes syncroneous writes would be significantly slower. I have not
>>> seen benchmarks on it, tho. Which applications typically use
>>> syncroneous IO? Maybe not that many. Do databases do that, eg
>>> postgresql and mysql?
>>>
>>
>> Database servers do use synchronous writes (or fsync() calls), but
>> I suspect that they won't suffer much if these are slow unless you
>> have a great deal of writes - they typically write to the
>> transaction log, fsync(), write to the database files, fsync(),
>> then write to the log again and fsync().  But they will buffer up
>> their writes as needed in a separate thread or process - it should
>> not hinder their read processes.
>>
>> Lots of other applications also use fsync() whenever they want to
>> be sure that data is written to the disk.  A prime example is
>> sqlite, which is used by many other programs.  If you have your
>> disk systems and file systems set up as a typical home user, there
>> is little problem - the disk write caches and file system caches
>> will ensure that the app thinks the write is complete long before
>> it hits the disk surfaces anyway (thus negating the whole point of
>> using fsync() in the first place...).  But if you have a more
>> paranoid setup, so that your databases or other files will not get
>> corrupted by power fails or OS crashes, then you have write
>> barriers enabled on the filesystems and write caches disabled on
>> the disks.
> I guess you mess things a bit - one should disable write cache or
> enable barriers at one time, not both. Here goes quote from XFS faq:
> "Write barrier support is enabled by default in XFS since kernel
> version 2.6.17. It is disabled by mounting the filesystem with
> "nobarrier". Barrier support will flush the write back cache at the
> appropriate times (such as on XFS log writes). "
> http://xfs.org/index.php/XFS_FAQ#Write_barrier_support.
>

Yes, thanks.  Usually I don't need to think about these things much, an=
d
when I do, I always have to look up the details to make sure I get the
combinations right.



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
