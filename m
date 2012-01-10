From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: raid array with 3T disks and GPT partition
Date: Tue, 10 Jan 2012 14:40:19 -0500
Message-ID: <4F0C9423.6000201@cfl.rr.com>
References: <20110901154759.GA32649@apartia.fr> <20110901155913.GA20825@cthulhu.home.robinhill.me.uk> <20110901163334.GA13347@apartia.fr> <4E5FB8EC.5040801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FB8EC.5040801@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/1/2011 12:55 PM, Doug Ledford wrote:
> Non-FS Data, which we hijacked for our purposes as it will keep the
> system (any OS in fact) from thinking there should be a filesystem
> there, leaving it free for us to pick up anytime in the boot process.

What do you mean?  Linux doesn't care what the partition type code says. 
  I brought that up on lkml a year or so back that it should at least 
respect the hidden flag and not expose that partition, but nobody seemed 
interested.

