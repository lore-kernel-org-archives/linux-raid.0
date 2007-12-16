From: Neil Brown <neilb@suse.de>
Subject: Re: Please Help!!! Raid 5 reshape failed!
Date: Mon, 17 Dec 2007 09:34:45 +1100
Message-ID: <18277.43013.910582.127818@notabene.brown>
References: <14339886.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from mangaskahn on Friday December 14
Sender: linux-raid-owner@vger.kernel.org
To: mangaskahn <mangaskahn@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 14, mangaskahn@yahoo.com wrote:
> 
> gentoofs ~#mdadm --assemble /dev/md1 /dev/sdc /dev/sdd /dev/sdf
> mdadm: /dev/md1 assembled from 2 drives - not enough to start the array

Try adding "--run".  or maybe "--force".

NeilBrown
