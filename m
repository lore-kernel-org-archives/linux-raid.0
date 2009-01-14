From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: Re: trouble adding spare
Date: Wed, 14 Jan 2009 15:23:47 +0200
Message-ID: <496DE763.9010300@fastmail.co.uk>
References: <496DB3A4.4090605@fastmail.co.uk> <alpine.DEB.1.10.0901140654100.11696@p34.internal.lan> <496DE2BD.6070905@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496DE2BD.6070905@fastmail.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Waterman wrote:
>> I would try:
>>
>> 1. mdadm --examine --scan
>> 2. Put that info into mdadm.conf.
It's already there - I think that's how I got the line in the first place.
>> 4. Otherwise, remove the spare from the array, zero the mdadm 
>> superblock.
How would I do this? I tried :

$ sudo /sbin/mdadm /dev/sdi --zero-superblock --force
mdadm: /dev/sdi does not appear to be an md device

Max.
