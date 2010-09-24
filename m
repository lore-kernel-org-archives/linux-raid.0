From: Jools Wills <jools@oxfordinspire.co.uk>
Subject: Re: ANNOUNCE: mdadm 3.1.4 - A tool for managing Soft RAID under Linux
Date: Fri, 24 Sep 2010 15:26:44 +0100
Message-ID: <4C9CB524.6090901@oxfordinspire.co.uk>
References: <19580.38720.309122.572004@notabene.brown>	<AANLkTimcC=h47qjkztW3cJ3Lh294Sbj6X=o3Zwfbh+E8@mail.gmail.com>	<20100922095000.03b3fd10@notabene> <AANLkTinmyrEdPgVvZUSb9Anc0w8_R5qGpqcQHeRQetAh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinmyrEdPgVvZUSb9Anc0w8_R5qGpqcQHeRQetAh@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "fibreraid@gmail.com" <fibreraid@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/09/10 15:19, fibreraid@gmail.com wrote:
> Thank you Neil! That absolutely solved the issue. Please take note
> Ubuntu users of this excellent recommendation.

Are you running your own ubuntu packages or someone elses btw ? since 
ubuntu doesn't even have 3.1.3 afaik.

i had the same behaviour as you on a new array until i did a 
update-initramfs "update-initramfs -k all -u" and then all was well - as 
it adds the mdadm.conf with to the initramfs (as has already been said). 
I wasn't 100% sure of the details why so thanks to Neil for clarifying this.

Best Regards

Jools Wills
-- 
IT Consultant
Oxford Inspire - http://www.oxfordinspire.co.uk - be inspired
t: 01235 519446 m: 07966 577498 f: 08715046117
jools@oxfordinspire.co.uk
