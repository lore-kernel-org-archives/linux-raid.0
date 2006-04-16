From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RHEL3 kernel panic with md
Date: Sun, 16 Apr 2006 14:05:46 -0400
Message-ID: <4442877A.5090608@tmr.com>
References: <bbfa52890604071447t2e791afai781522f9f204485d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bbfa52890604071447t2e791afai781522f9f204485d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Colin McDonald <ce.mcdonald@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Colin McDonald wrote:

>I appear to have a corrupt file system and now it is mirrored. LOL.
>
>I am running Redhat Enterprise 3 and using mdtools.
>
>I booted from the install media iso and went into rescue mode. RH was
>unable to find the partitions automatically but after exiting into
>bash i can run fdisk -l and i see all of the partitions.
>
>I know this is sparse info but would any of the group be able to give
>the best approach to getting them  mounted and fsck'd?
>

I'm happy to say I haven't tried this, but I would think that you can 
start the raid array manually and then run fsck (also manually). I would 
worry about why the rescue mode didn't find your data, though.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

