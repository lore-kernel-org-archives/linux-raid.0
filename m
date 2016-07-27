From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: SOLVED [was Re: GPT corruption on Primary Header, backup OK,
 fixing primary nuked array -- help?]
Date: Wed, 27 Jul 2016 18:12:42 -0500
Message-ID: <57993FEA.20407@suddenlinkmail.com>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
 <5797C415.8010206@suddenlinkmail.com>
 <CAJCQCtSkE+-C5U9OEm0-zazLW2KHCMUqduDTA=UHsMxmf4DVrQ@mail.gmail.com>
 <5797E869.8080403@suddenlinkmail.com>
 <CAJCQCtQpGVf2Tj13o57T4=raF=czYr-V99tEDSkJ-_buk7JtTg@mail.gmail.com>
 <57985F10.4070706@suddenlinkmail.com>
 <f0ebae2f-472f-6835-d74b-f3fccd4c6b04@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f0ebae2f-472f-6835-d74b-f3fccd4c6b04@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/27/2016 09:22 AM, Phil Turmel wrote:
> I always place of=/dev/.... last on a dd command line just in case.
> 
> Using dd to write near the end of a member device is entirely safe while
> running if the location is after the "Used Data Area"+"Data Offset" of
> the device, as reported by mdadm --examine.
> 
> If you are zeroing a backup GPT that has corrupted part of your data
> inside the data area, it doesn't do any additional harm.  So don't
> bother using --fail and --remove on the member devices.

I wondered about that, but I figured it was safer to take the drive out of the
array and operate on each separately. One more chunk of good learning that has
come out of this thread for me. Thanks.

-- 
David C. Rankin, J.D.,P.E.
