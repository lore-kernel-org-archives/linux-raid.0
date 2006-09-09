From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: Please help me save my data
Date: Sat, 9 Sep 2006 19:00:53 +0300
Message-ID: <5b170a7d0609090900v3fe18cc9g3b405aa7d848fc99@mail.gmail.com>
References: <57786.213.136.43.252.1157721982.squirrel@webmail.adocca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57786.213.136.43.252.1157721982.squirrel@webmail.adocca.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "martin.kihlgren@adocca.com" <martin.kihlgren@adocca.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On 9/8/06, martin.kihlgren@adocca.com <martin.kihlgren@adocca.com> wrote:
> So, what I want to do is:
>
>  * Mark the synced spare drive as working and in position 1
>  * Assemble the array without the unsynced spare and check if this
>    provides consistent data
>  * If it didnt, I want to mark the synced spare as working and in
>    position 3, and try the same thing again
>  * When I have it working, I just want to add the unsynced spare and
>    let it sync normally
>  * Then I will create a write-intent bitmap to avoid the dangerously
>    long sync times, and also buy a new USB controller hoping that it
>    will solve my problems

You can recreate the raid array with 1 missing disk, like this:

mdadm -C /dev/md1 /dev/sdn1 /dev/sdX1 /dev/sdn1 /dev/sdn1 missing

The ordering is relevant, raid-disks 0,1,2,3,4 or so. beware, you have
to have block size and symmetry correct, so better backup mdadm
--examine and --detail output beforehand.

This create op causes no sync (no danger data overwrites), as there is
still the one drive missing, but raid-superblocks are rewritten.

(On a sidenote, i'm uncertain if a bitmap helps in the case of
single-device remove-add cycle? I thought it was only for crashes, at
least for now..)
