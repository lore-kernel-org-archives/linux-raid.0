From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: MDADM RAID 6 Bad Superblock after reboot
Date: Thu, 19 Oct 2017 11:58:48 +0100
Message-ID: <59E88568.6060108@youngman.org.uk>
References: <6a0f0e0b-6b03-8ec1-b02f-b17b0447aff8@gmail.com>
 <AA5FDF15-8966-4793-9215-2814C1A6848D@gmail.com>
 <59E7AE4B.5000903@youngman.org.uk>
 <63c30fde-d2df-bb92-d6c9-d231a955b5ce@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <63c30fde-d2df-bb92-d6c9-d231a955b5ce@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: sfunk1x <sfunk1x@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/10/17 02:52, sfunk1x wrote:
> Thanks for the vote of confidence in not losing data here. As I
> mentioned above, I've set SELinux into permissive mode. I'm sort of at a
> loss as to what to do next. Since sd[fgh] don't have any superblock
> data, can I try to bring the array back online with 5 drives, then
> re-add the last three, with the hope that they sync? There obviously
> hasn't been any writes to the last three drives since the hard system
> reboot, so I'd hope their event numbers would be in sync?

Okay. First thing I'd try is temporarily get rid of mdadm.conf. You
don't actually need it. Then do "mdadm --stop /dev/md0" followed by
"mdadm --assemble --scan".

That'll tell mdadm to do a "best effort" to get everything running.
*Always* do an mdadm --stop between every attempt, because the quickest
way to mess up recovery attempts is to have the wreckage of a previous
attempt lying around.

If that doesn't work, then try assembling the array explicitly, ie
listing all the drives. I can't remember whether order is important - so
long as you don't specify --force it'll either work or fail, it won't do
any damage.

Beyond this point I'm getting out of my depth, I don't have the broad
experience so I'll have to step back and let others chime in, but
there's a good chance this will get your array back.

Cheers,
Wol
