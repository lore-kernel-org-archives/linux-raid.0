From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: /proc/mdstat status documentation and md: export_rdev
Date: Fri, 29 Nov 2013 18:18:13 +0200
Message-ID: <82FCA6B9-10FD-4D56-83D1-87C5FC36B712@gmail.com>
References: <E90CEDA2-1AF7-4FCF-91F6-346D644CF674@gmail.com> <CB92E3E9-672C-456F-9767-719159BC0CE5@gmail.com> <52978F67.2050900@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52978F67.2050900@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 28, 2013, at 8:45 PM, Can Jeuleers <can.jeuleers@gmail.com> wrote:

> On 11/28/2013 06:11 PM, Ivan Lezhnjov IV wrote:
>> I would appreciate it if someone pointed out if there is a documentation that can be used to interpret all the codes that appear in /proc/mdstat output. For example, I know that (F) means that an array member's status is Failed, but what about (S)? Are there any other status codes like that? What are their meanings?
> 
> Use the code Luke :-)
> 
> See drivers/md/md.c:md_seq_show(). This suggests:
> 
> (W) means write-mostly
> (F) means faulty
> (S) means spare
> 
> HH, Jan

This is great. Thank you. I'm not fluent at C but it sheds at least some light on this.

Also, it looks like rdev is a "raid device" as opposed to bdev being "block device" but it's interesting how the flow of assembling array looks like. Any chance you or anyone else know where i could read a description without having to decipher the md.c?

Ivan