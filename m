From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: RAID6 questions
Date: Thu, 2 Jul 2009 18:13:39 -0400
Message-ID: <87f94c370907021513mfd59e27g87e0deac74e4bfb9@mail.gmail.com>
References: <2bdd5a4c0907020822s7d136681g23a4e34e13f0be8@mail.gmail.com>
	 <871vozox2r.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871vozox2r.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Marek <mlf.conv@gmail.com>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Thu, Jul 2, 2009 at 12:42 PM, Goswin von Brederlow<goswin-v-b@web.de> wrote:
> Marek <mlf.conv@gmail.com> writes:
<snip>
>> 6. Is it safe to have 20+ partitions for a RAID5,6 system? Most RAID
>> related sources state that there's a limitation on number of
>> partitions one can have on SATA drives(AFAIK 16), but i digged out
>> some information about a recent patch which would remove this
>> limitation and which according to some other source had also been
>> accepted into mainline kernel, though I'm not sure about it.
>> http://thread.gmane.org/gmane.linux.kernel/701825
>> http://lwn.net/Articles/289927/
>
> Should be 15 or unlimited. Look at the major/minor numbers of sda* and
> sdb. After sda15 there is no space before sdb comes. So unless sda16
> gets a dynamic major/minor it can't be accessed.
>
> It certainly is safe. But it seems stupid as well.

That patch went in 2.6.29 I'm pretty sure.  Not that I have ever
needed more than 15 partitions on one drive.

And yes major/minor after the first 15 are now dynamic I believe.

Greg
-- 
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Paper -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
