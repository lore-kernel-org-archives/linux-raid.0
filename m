From: martin.kihlgren@adocca.com
Subject: Re: Please help me save my data
Date: Mon, 11 Sep 2006 14:16:29 +0200 (CEST)
Message-ID: <59430.213.136.43.252.1157976989.squirrel@webmail.adocca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On 9/8/06, martin.kihlgren@adocca.com <martin.kihlgren@adocca.com> wrote:
>> So, what I want to do is:
>>
>>  * Mark the synced spare drive as working and in position 1
>>  * Assemble the array without the unsynced spare and check if this
>>    provides consistent data
>>  * If it didnt, I want to mark the synced spare as working and in
>>    position 3, and try the same thing again
>>  * When I have it working, I just want to add the unsynced spare and
>>    let it sync normally
>>  * Then I will create a write-intent bitmap to avoid the dangerously
>>    long sync times, and also buy a new USB controller hoping that it
will solve my problems
>
> You can recreate the raid array with 1 missing disk, like this:
>
> mdadm -C /dev/md1 /dev/sdn1 /dev/sdX1 /dev/sdn1 /dev/sdn1 missing
>
> The ordering is relevant, raid-disks 0,1,2,3,4 or so. beware, you have
to have block size and symmetry correct, so better backup mdadm
> --examine and --detail output beforehand.
>
> This create op causes no sync (no danger data overwrites), as there is
still the one drive missing, but raid-superblocks are rewritten.
>
> (On a sidenote, i'm uncertain if a bitmap helps in the case of
> single-device remove-add cycle? I thought it was only for crashes, at
least for now..)
>

Thanks for your help! Your advice is good, and I will use it next time.

This time I found an old USB memory stick to experiment with, and managed
to do pretty much the same thing with:

mdadm -C -l 5 -n 5 -f -e 1.2 --assume-clean /dev/md1 /dev....
mdadm -f /dev/md1 /dev/borken_device

And yes, the ordering was very relevant. An xfs_check showed me which
ordering was correct however. But I still have a problem with not easily
knowing what physical drive is what raid device, since USB devices get
ordered in some random way.

And no, the bitmap didnt help in this case (it has happened again but with
only one disk)... I wish my USB worked better, but I guess its a question
of time and kernel development.

Thanks anyhow!
regards,
//Martin

