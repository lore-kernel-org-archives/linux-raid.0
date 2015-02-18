From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: md_raid5 using 100% CPU and hang with status resync=PENDING, if a drive is removed during initialization
Date: Tue, 17 Feb 2015 19:03:30 -0500
Message-ID: <wrfj61b0gk6l.fsf@redhat.com>
References: <CD8664C5675EDF49A5E76D7DB099D7B32611BB56@VENUS1.in.megatrends.com>
	<20141231164800.GL19091@reaktio.net>
	<CD8664C5675EDF49A5E76D7DB099D7B326130D6E@VENUS1.in.megatrends.com>
	<20150203093040.569aa5e1@notabene.brown> <wrfjpp99pp9d.fsf@redhat.com>
	<wrfjd259o4iy.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjd259o4iy.fsf@redhat.com> (Jes Sorensen's message of "Mon, 16
	Feb 2015 17:49:57 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Manibalan P <pmanibalan@amiindia.co.in>, Pasi =?utf-8?B?S8Okcmtrw6Rp?= =?utf-8?B?bmVu?= <pasik@iki.fi>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>> NeilBrown <neilb@suse.de> writes:
>>> On Mon, 2 Feb 2015 07:10:14 +0000 Manibalan P <pmanibalan@amiindia.co.in>
>>> wrote:
>>>
>>>> Dear All,
>>>> 	Any updates on this issue.
>>>
>>> Probably the same as:
>>>
>>>   http://marc.info/?l=linux-raid&m=142283560704091&w=2
>>
>> Hi Neil,
>>
>> I ran some tests on this one against the latest Linus' tree as of today
>> (1fa185ebcbcefdc5229c783450c9f0439a69f0c1) which I believe includes all
>> your pending 3.20 patches.
>>
>> I am able to reproduce Manibalan's hangs on a system with 4 SSDs if I
>> run fio on top of a device while it is resyncing and I fail one of the
>> devices.
>
> Since Manibalan mentioned this issue wasn't present in earlier kernels,
> I started trying to track down what change caused it.
>
> So far I have been able to reproduce the hang as far back as 3.10.

After a lot of bisecting I finally traced the issue back to this commit:

a7854487cd7128a30a7f4f5259de9f67d5efb95f is the first bad commit
commit a7854487cd7128a30a7f4f5259de9f67d5efb95f
Author: Alexander Lyakas <alex.bolshoy@gmail.com>
Date:   Thu Oct 11 13:50:12 2012 +1100

    md: When RAID5 is dirty, force reconstruct-write instead of read-modify-write.
    
    Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
    Suggested-by: Yair Hershko <yair@zadarastorage.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

If I revert that one I cannot reproduce the hang, applying it reproduces
the hang consistently.

Cheers,
Jes
