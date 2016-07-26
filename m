From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 15:12:05 -0500
Message-ID: <5797C415.8010206@suddenlinkmail.com>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/26/2016 04:52 AM, Adam Goryachev wrote:
> No, I'm saying that is an excellent idea, and it is exactly what I always do.
> The problem is that you created the single large primary partition, and then
> used the raw drive for the raid array instead of using the partition.

Damn, that is exactly what I did, even though I intended to use sdc1 and sdd1.
Checking bash_history for root, I find:

mdadm --create --verbose --level=1 --metadata=1.2 --raid-devices=2 /dev/md4
/dev/sdc /dev/sdd

then

mkfs.ext4 -v -L data -m 0.005 -b 4096 -E stride=16,stripe-width=32 /dev/md4

So basically I just need to fix the partition table on sdc, that will leave both
sdc and sdd with health partition tables and a primary partition of sdc1 and
sdd1. I'll blow away the current degraded md4 and recreate md4 with

mdadm --create --verbose --level=1 --metadata=1.2 --raid-devices=2 /dev/md4
/dev/sdc1 /dev/sdd1

mkfs.ext4 -v -L data -m 0.005 -b 4096 -E stride=16,stripe-width=32 /dev/md4

Then its just a matter of re-copying the data, uncommenting fstab and updating
mdadm.conf?

This even solved the mystery of where the original corruption came from. That's
a hole in one.

As for either shrinking the filesystem on sdc to fit on sdc1 and sdd1, is that
worth attempting, or is it probably better to just blow away the existing array
and then recreate it all as indicated above? If I can save the filesystem, I
save a few hours of formatting, but I worry about the reliability of shrinking
the filesystem. (there is plenty of room, I have 258G used out of 2.7T) What is
the consensus? Is shrinking reliable, or is it something to consider as a worse
case scenario (as in the hypothetical replacing of a disk that is slightly
smaller than the failed one)?

Thank you again for your help. Glad to see Murphy's law is still well in force
and effect. (an entire PT mystery caused by some dummy that forgot to append the
'1' during the mdadm --create -- who would have imagined :)

-- 
David C. Rankin, J.D.,P.E.
