From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Is My Data DESTROYED?!
Date: Tue, 27 Oct 2009 16:45:15 -0400
Message-ID: <4AE75BDB.1020908@tmr.com>
References: <812581.75103.qm@web38808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <812581.75103.qm@web38808.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

adfas asd wrote:
> Thanks.  But what I have in mind is serving the HTPC's array (with videos)to the storage server via iSCSI.  Hopefully the array can be mounted on the HTPS and still be served to the remote storage server by iSCSI?
>   

One more time, if you mount the backup copy on the main server it will 
then be subject to the same failure issues as a mirror. You want to use 
something like rsync to backup over network, and the function of the 
backup server isn't going to be to serve other than in case of 
emergency. You don't want to serve, to mount, to do anything which will 
let filesystem, OS, or user errors propagate to the backup copy.

Other than the reliability issue if you mount, there's no reason to 
avoid things like NFS, they are well tested but not stagnant, getting 
significant upgrades a few years ago and regular minor glitch fixes for 
corner cases. In general cutting edge and reliable is not the most 
probable combination. While NFS is widely used and maintained, protocols 
like AFS, iSCSI and sshfs are used by fewer sites, and perhaps more 
experienced administrators, so perhaps they are less tested, 
particularly in the area of less than optimal setup.

Boring and uneventful is what you want in a backup system.

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

