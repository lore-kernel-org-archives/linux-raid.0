From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Intel fakeraid working?
Date: Thu, 05 Apr 2012 14:20:53 -0400
Message-ID: <4F7DE285.90503@ubuntu.com>
References: <4F7CEDD0.9080904@ubuntu.com> <20120405111317.2a5227b1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120405111317.2a5227b1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/4/2012 9:13 PM, NeilBrown wrote:
> If the array was activated read-only, that suggests that 'mdmon' didn't run.
> mdmon is a daemon which monitors the array and updates the metadata as
> needed.  until it is running it is not safe for the array to be writable.
> However it should be started automatically by mdadm.

That explains it... mdmon does not appear to have been added to the 
Ubuntu package.

> How are you attempting to start the array?

mdadm --activate --scan


