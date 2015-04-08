From: "Jonathan Harker (Jesusaurus)" <jesusaurus@gentlydownthe.net>
Subject: Re: Help recovering an interrupted raid0 reshape
Date: Wed, 8 Apr 2015 10:00:32 -0700
Message-ID: <CAC_83AHf-eV-wb=p+guPKqaLVoedfqVA=EMXMRiTPj5pJuLBAA@mail.gmail.com>
References: <CAC_83AFDEijn-7gNmnWNNabzcuPRMabNwr8xfRFt0xacsvZfog@mail.gmail.com>
	<20150407094608.4a9dd142@notabene.brown>
	<20150407115033.1d63b65c@notabene.brown>
	<CAC_83AFo47Zfe7rMqro7_k8dR-xpMcfiwQA7a9DTKpKPuHr=fA@mail.gmail.com>
	<20150407163004.7550da77@notabene.brown>
	<CAC_83AEtgtiN-WD-U8OG_nzsoRWQmrn6mxKMhKk6cxK4ZD5yaQ@mail.gmail.com>
	<20150408071339.3295567b@notabene.brown>
	<CAC_83AGk2MK8=qy2CL-WN-ewfVzgA2D-WRkefpriXrdHSEjU-Q@mail.gmail.com>
	<20150408085635.64fa7101@notabene.brown>
	<CAC_83AF0EHVVDF7Gwdfw9WB34v+nHCFmpjLR7AQ5qOz5QATgdQ@mail.gmail.com>
	<20150408120955.692b2564@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150408120955.692b2564@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 7, 2015 at 7:09 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 7 Apr 2015 16:24:35 -0700 "Jonathan Harker (Jesusaurus)"
> <jesusaurus@gentlydownthe.net> wrote:
>
>> On Tue, Apr 7, 2015 at 3:56 PM, NeilBrown <neilb@suse.de> wrote:
>> >
>> >
>> > Hmm... I think I see the bug.  It should be easy enough to fix, but I'd like
>> > to be able to test it.
>> > Could you please:
>> >
>> >  mkdir /tmp/md.metadata
>> >  mdadm --dump /tmp/md.metadata /dev/md/alpha /dev/md/beta /dev/md/gamma
>> >  tar czSf /tmp/md.tgz /tmp/md.metadata
>> >
>> > and then send me /tmp/md.tgz, which should be tiny and contain just the
>> > metadata from the array.
>>
>> I'll send that to you once tar finishes.
>
> Thanks.  And just as well I tested as there was another problem.
> I think it is all fixed now.
> If you:
>
>  cd /tmp
>  git clone git://neil.brown.name/mdadm
>  cd mdadm
>  make
>  ./mdadm -A /dev/md124 --force -vvvv /dev/md/{alpha,beta,gamma}
>
> it should assemble the array and continue the reshape.
>
> When it finishes it will leave the array as degraded RAID4.
> Simply:
>   mdadm /dev/md125 --grow --level=0
>
> and it will instantly become RAID0.
>
> NeilBrown
>
>>
>> >
>> > [[the patch which introduced the problem has a description which starts
>> >     "This is a bit of a hack and ..."
>> >   Never accept hacks!
>> > ]]
>>
>> I've reviewed and accepted a few hacks in my day as well. Hopefully
>> the cleanup isn't too ugly.
>> Thanks again for looking into this.
>>
>

Awesome, the interrupted reshape has restarted! And in about 900 short
minutes I should be able to reshape back to a raid0.
Thanks again for all your help.

-- 
Jonathan
