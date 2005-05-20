From: Doug Ledford <dledford@redhat.com>
Subject: Re: Multipath issues with gentoo
Date: Fri, 20 May 2005 18:03:06 -0400
Message-ID: <1116626586.23785.158.camel@compaq-rhel4.xsintricity.com>
References: <1115829789.a20b141cglore24d@erau.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1115829789.a20b141cglore24d@erau.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Nolan Glore <glore24d@erau.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2005-05-11 at 12:43 -0400, Nolan Glore wrote:

> If I try and take advantage of the mdadm.conf file and execute this command to start md0: 
>  
> Code: 
>  
> mdadm -As
>  
> 
> I get the following message: 
>  
> Code: 
>  
> mdadm: failed to add /dev/sdd1 to /dev/md0: Device or resource busy 
> mdadm: /dev/md0 has been started with 1 drive (out of 2). 

Hmmm...I wonder if, in scan mode, mdadm has a bug related to not closing
the sdd1 file handle prior to trying to use sdd1 in an md array?  Maybe
during scan mode when it finds the last device it needs to assemble an
array it's jumping the gun and trying to assemble before closing out the
device it just scanned.  Neil?

-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


