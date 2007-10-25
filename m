From: Neil Brown <neilb@suse.de>
Subject: Re: deleting mdadm array?
Date: Thu, 25 Oct 2007 18:17:11 +1000
Message-ID: <18208.20743.897391.958853@notabene.brown>
References: <20071025100619.3b3810be@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Janek Kozicki on Thursday October 25
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 25, janek_listy@wp.pl wrote:
> Hello,
> 
> I just created a new array /dev/md1 like this:
> 
> mdadm --create --verbose /dev/md1 --chunk=64 --level=raid5 \
>    --metadata=1.1  --bitmap=internal \
>    --raid-devices=3 /dev/hdc2 /dev/sda2 missing
> 
> 
> But later I changed my mind, and I wanted to use chunk 128. Do I need
> to delete this array somehow first, or can I just create an array
> again (overwriting the current one)?

Just recreate with new values, overwriting the current one.

NeilBrown
