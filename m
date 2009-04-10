From: KwangErn Liew <admin@musmo.com>
Subject: Re: Converting system to raid
Date: Fri, 10 Apr 2009 11:10:30 +0200
Message-ID: <49DF0D06.8030705@musmo.com>
References: <003801c9b96d$21a0f420$0a00a8c0@vorg>
Reply-To: admin@musmo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003801c9b96d$21a0f420$0a00a8c0@vorg>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Timothy D. Lenz wrote:
> Ended with warning: unable to open an initial console. I was able to scroll back and didn't really see any errors. Don't know if I
> missed a change to some config file or something else that should be built into the kernel. I have gone over a lot of "guides" and
> don't see what is missing.

FYI, I've never been successful in booting RAID without initrd even 
though all necessary modules are built-in. I guess mdadm.conf requires 
initrd to kick start?


KwangErn
