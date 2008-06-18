From: "michael@kmaclub.com" <michael@kmaclub.com>
Subject: Re: Confused about UUID mounting and mirrors
Date: Wed, 18 Jun 2008 07:42:05 -0700
Message-ID: <48591EBD.4020308@kmaclub.com>
References: <4856A8C6.3030609@kmaclub.com> <4856CFE1.1020105@ziu.info> <4856DB4C.20905@kmaclub.com> <4856DD5B.9050303@dgreaves.com> <485721A5.3080101@kmaclub.com> <48576394.8090609@msgid.tls.msk.ru> <4857C7FC.9000000@kmaclub.com> <485914E7.1000800@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <485914E7.1000800@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: David Greaves <david@dgreaves.com>, Michal Soltys <soltys@ziu.info>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
> michael@kmaclub.com wrote:
> []
>> Using the filesystem ID doesn't work either because /dev/sda, 
>> /dev/sdb, and /dev/md0 all have the same UUID since it is a mirror.  
>> How do you tell the system to mount /dev/md0 and not the individual 
>> drives which is what it is trying to do now.
> 
> The tools/library that looks up filesystem UUIDs/labels are smarter than
> that.  Or are supposed to be smarter.  That it - the tools are able to
> recognize and skip components of a raid array, since raid superblock is
> present on the device - which is not present on the array itself.


Ok.  Thanks,

I will play with this more tonight and see I did something wrong the 
first time I tried it.

Thanks for all the suggestions.

Michael

