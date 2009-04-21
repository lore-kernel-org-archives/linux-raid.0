From: Neil Brown <neilb@suse.de>
Subject: Re: Poor write performance with write-intent bitmap?
Date: Tue, 21 Apr 2009 15:50:41 +1000
Message-ID: <18925.24241.19288.797776@notabene.brown>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
	<49ED096E.1000002@anonymous.org.uk>
	<49ED16F7.3040906@anonymous.org.uk>
	<4081b80da35818efbc07723240f8ea36.squirrel@neil.brown.name>
	<49ED2BC3.7050109@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from John Robinson on Tuesday April 21
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday April 21, john.robinson@anonymous.org.uk wrote:
> 
> Eeek! Trying to `mdadm --grow /dev/md1 --bitmap=none` from my large 
> chunk size caused a reboot! There's nothing in the log, and I didn't see 
> the console. I still have my 32M chunksize but I don't want to try that 
> again in a hurry :-)

That's a worry... I cannot easily reproduce it.  If it happens again
and you get any more detail, I'm sure you'll let me know.

Thanks,
NeilBrown
