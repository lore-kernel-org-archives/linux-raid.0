From: EJ Vincent <ej@ejane.org>
Subject: Re: Degraded Raid6
Date: Thu, 13 Dec 2012 14:17:15 -0500
Message-ID: <50CA29BB.5070407@ejane.org>
References: <15214561.24.1355424666351.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15214561.24.1355424666351.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/13/2012 1:51 PM, Roy Sigurd Karlsbakk wrote:
>> I run an 8-disk raid 6 on which sporadically 2 drives dropped out,
>> that I could just re-add when I zeroed the zuperblock beforehand.
>> Recently, upon re-adding those 2 drives (after the zero-superblock) a
>> third drive dropped out after 5-10 minutes of syncing. I then did a
>> zero-superblock on the third drive and tried to re-add it - which
>> failed.
> ...
>> 10 8 113 - spare /dev/sdh1
>> 11 8 1 - spare /dev/sda1
>> 12 8 65 - spare /dev/sde1
> If you had two drives failing, why didn't you let these spares take over the job?

Roy,

AFAIK, they were mistakenly labeled as spares, *after* the failure 
occurred.  sdh, sda, and sde were original members of his array.

-EJ

