From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Please help!  How to reconstitute array (drive order problem)?
Date: Wed, 27 Oct 2004 15:51:45 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410271951.i9RJppN06017@www.watkins-home.com>
References: <m3y8hs1hwu.fsf@bfnet.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m3y8hs1hwu.fsf@bfnet.com>
To: 'David Wuertele' <dave-gnus@bfnet.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Glad you read the man page.  Most people seem too lazy to learn something.

I like mdadm, so I would create the config file.

Jim gave away the answer!
Or you could do as Jim Paris said:
"So your drives are now hde, hdg, hdo, hdh, hdm, hdn, hdp.  Something like
  mdadm --assemble /dev/md0 hd[egohmnp]
should do the trick."

Ha!  Maybe Jim did a typo!  Try this:
mdadm --assemble /dev/md0 /dev/hd[egohmnp]
Just make sure you list the current/correct devices.
If they were partitioned, be sure to use the partitions!
If each disk had 1 partition, this would be the correct command:
mdadm --assemble /dev/md0 /dev/hd[egohmnp]1

The "--auto" is new to me.  I have an old version.

The UUID is a unique ID.  Every disk that makes up the array will have the
same ID.

"--scan" requires a config file.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Wuertele
Sent: Wednesday, October 27, 2004 8:10 AM
To: linux-raid@vger.kernel.org
Subject: Re: Please help! How to reconstitute array (drive order problem)?

Guy> Use mdadm to start your array.
Guy> Details: "man mdadm"
Guy> You may need to install mdadm.

Wow, looks like mdadm is a lifesaver.  After reading the man page, it
looks like I should run

    mdadm --assemble --scan /dev/md0 --auto=yes

Will this find all seven of the component partitions that make up the
md0 RAID5?  Or do I have to list those partitions in the config file?

From the man page: "The identity can be given with the --uuid option,
  with the --super- minor option, can be found in the config file, or
  will be taken from the super block on the first component-device
  listed on the command line."

What is an "identity" or a "uuid"?  Does that mean "/dev/md0"?

Thanks,
Dave

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

