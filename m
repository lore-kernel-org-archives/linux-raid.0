From: Brendan Conoboy <blc@redhat.com>
Subject: Re: Configuring RAID5 w/ Spare?
Date: Thu, 11 Mar 2010 11:24:55 -0700
Message-ID: <4B993577.2070501@redhat.com>
References: <d80f793f1003111011m588e1bdem3a9d934ff0fdc35e@mail.gmail.com>	 <4B993370.2040003@redhat.com> <d80f793f1003111018n3b769299m9a5bd8f4a46e2678@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d80f793f1003111018n3b769299m9a5bd8f4a46e2678@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Mennens <carloswill@gmail.com>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/11/2010 11:18 AM, Carlos Mennens wrote:
> OK so you're just saying all I should change is partition /dev/sdd as
> I did the rest? I don't however need to format this when installing my
> Linux O.S., correct? I should just skip formatting and mount point
> assignment since it's a hot spare?

Right.  In reality the only "formatting" that takes place on these 
partitions is when you run the mdadm command: It combines the partitions 
according to your command line arguments, producing a new block device, 
/dev/mdX.  It's /dev/mdX that you format (or put LVM on, then create a 
physical volume.. then a volume group... then a logical volume... then 
format that with a filesystem).

-- 
Brendan Conoboy / Red Hat, Inc. / blc@redhat.com
