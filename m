From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Intel fakeraid working?
Date: Fri, 06 Apr 2012 12:36:56 +0200
Message-ID: <4F7EC748.1020408@computer.org>
References: <4F7CEDD0.9080904@ubuntu.com> <20120405111317.2a5227b1@notabene.brown> <4F7DE285.90503@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F7DE285.90503@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: NeilBrown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/04/12 20:20, Phillip Susi wrote:
> On 4/4/2012 9:13 PM, NeilBrown wrote:
>> If the array was activated read-only, that suggests that 'mdmon'
>> didn't run.
>> mdmon is a daemon which monitors the array and updates the metadata as
>> needed. until it is running it is not safe for the array to be writable.
>> However it should be started automatically by mdadm.
>
> That explains it... mdmon does not appear to have been added to the
> Ubuntu package.

https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/957494

