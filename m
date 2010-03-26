From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: 4 partition raid 5 with 2 disks active and 2 spare, how to force?
Date: Thu, 25 Mar 2010 20:38:27 -0700
Message-ID: <4877c76c1003252038o655b2a29p9d994df27b5d2afd@mail.gmail.com>
References: <S1753093Ab0CYHZE/20100325072504Z+37@vger.kernel.org>
	 <2E4545D6-8F4E-4779-9103-960C52983A72@brillgene.com>
	 <4877c76c1003250437r346e18en8da0f6f804bef634@mail.gmail.com>
	 <DFC0232A-8DCD-4815-AA08-DA7065F01221@brillgene.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DFC0232A-8DCD-4815-AA08-DA7065F01221@brillgene.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman@brillgene.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 25, 2010 at 7:09 AM, Anshuman Aggarwal
<anshuman@brillgene.com> wrote:
> Thanks Michael, I am clear about the problem of why the multiple fail=
ure would cause me to lose data. Which is why I wanted to consult this =
mailing list before proceeding.
>
> Could you tell me how to keep the array read-only? =A0and mark one or=
 both of these spares as active forcibly? and Also, once I am able to u=
se these spares as active and the data is not consistent in a particula=
r stripe, how does the kernel resolve the inconsistency (as in what dat=
a does it use, the one based on the data stripes or the one based on th=
e parity?) this one is just academic interest since it'll be difficult =
to figure out which is the right data anyways.
>
> Thanks,
> Anshuman
>

Please, read the wikipedia page first,

http://en.wikipedia.org/wiki/RAID

and then this

http://wiki.tldp.org/LVM-on-RAID (some links need updating, but it's
still up to date for concepts)


With that background nearly out of the way, please stop, and read them
both again.  Yes, seriously.  In order to prevent data loss you'll
need to have a good understanding of what RAID does, so that you can
watch out for ways it can fail.

The next step, before we do /anything/ else is for you to post the
COMPLETE output of these commands.

mdadm -Dvvs
mdadm -Evvs

They will help everyone on the list better understand the state of the
metadata records and what potential solutions might be possible.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
