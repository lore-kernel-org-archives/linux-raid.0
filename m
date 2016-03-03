From: Another Sillyname <anothersname@googlemail.com>
Subject: Re: Fwd: RAID6 Array crash during reshape.....now will not re-assemble.
Date: Thu, 3 Mar 2016 22:19:15 +0000
Message-ID: <CAOS+5GFfNdeYrfw6j_LowkW+g69h2fEOikHN1=-VQ98ZF9Jtpg@mail.gmail.com>
References: <CAOS+5GEd4E2wzYhw0rPdrZnjK6UwAUdKCQLLTxXrdPO8d7hS7w@mail.gmail.com>
	<56D6E883.50801@youngman.org.uk>
	<CAOS+5GHof=F94x58SKqFojV26hGpDSLF85dFfm8Xc6M43sN6jA@mail.gmail.com>
	<CAOS+5GEfQ2p0xguguKC3uXW8GYBDCxt2vk=-Ci6+nTKwkcWtdQ@mail.gmail.com>
	<CAOS+5GGX8QBo3=s+Mcj=Kd6VSmZyatfZ30NXBy8E=4WJE6z0sA@mail.gmail.com>
	<CAOS+5GGB5gVSFJbYwwJu+z0C0oyYPzsLRhnjD6FkmLEWFFquFA@mail.gmail.com>
	<56D8348E.9070802@youngman.org.uk>
	<CAOS+5GH1Rcu8zGk1dQ+aSNmVzjo=irH65KfPuq1ZGruzqX_=vg@mail.gmail.com>
	<CAOS+5GHUKD63M90zWfiv14QkJunj2QF+gYqDMrg208-S4oXE2Q@mail.gmail.com>
	<56D878E8.1060409@prgmr.com>
	<CAOS+5GEnvtPMUqorddDNUvkNr2+K2S=0N76i3f0AkAOE-7U4Pg@mail.gmail.com>
	<22232.41693.691818.451316@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22232.41693.691818.451316@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John

Thanks for the suggestion but that's still 'trying' things rather then
an analytical approach.

I also do not want to reboot this machine until I absolutely have to
incase I need to capture any data needed to identify and thereby
resolve the problem.

Given I'm not getting much joy here I think I'll have to post a bug
tomorrow and see where that goes.

Thanks again.



On 3 March 2016 at 20:47, John Stoffel <john@stoffel.org> wrote:
>
> Have you tried pulling down the latest version of mdadm from Neil's
> site with:
>
>      git clone git://neil.brown.name/mdadm/ mdadm
>      cd mdadm
>      ./configure
>      make
>
> and seeing if that custom build does the trick for you?  I know he's
> done some newer patches which might help in this case.
>
>
> Another> I'd read that a couple of days back and while it's an interesting idea
> Another> I don't believe it will address my specific issue of the array not
> Another> allowing re-assembly (even with force and read only flags set) as
> Another> mdadm reports the 'need backup file for reshape, sorry' error no
> Another> matter what I've tried.
>
> Another> Even trying the above flags with invalid-backup does not work so I
> Another> need someone to have a eureka moment and say "....it's this....".
>
> Another> I believe that mdadm 3.3 incorporated the recover during reshape
> Another> functionality, however I've read elsewhere it only applies to
> Another> expansion into a new drive...I was going RAID6 to RAID5 (even though
> Another> it never really got started) and the backup file looks like 20mb of
> Another> EOLs.
>
> Another> So at he moment I'm pretty much stuck unless someone can tell me how
> Another> to clear down the reshape flag, even in read only mode so I can copy
> Another> the data off.
>
>
> Another> On 3 March 2016 at 17:48, Sarah Newman <srn@prgmr.com> wrote:
>>> On 03/03/2016 06:07 AM, Another Sillyname wrote:
>>>> Plenty of hits....but no clear fixes and as I said I'm not willing to
>>>> 'try' things from google hits until someone with better insight can
>>>> give me a view.
>>>>
>>>> Trying things is fine in many instances, but not with a 20+TB data set
>>>> as I'm sure you can understand.
>>>>
>>>
>>> I have not tried this personally, but it may be of interest:
>>> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file I found this explanation
>>> of the dmsetup commands to be more easy to follow: http://www.flaterco.com/kb/sandbox.html
>>>
> Another> --
> Another> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> Another> the body of a message to majordomo@vger.kernel.org
> Another> More majordomo info at  http://vger.kernel.org/majordomo-info.html
