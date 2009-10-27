From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Is My Data DESTROYED?!
Date: Tue, 27 Oct 2009 15:36:30 +0100
Message-ID: <20091027143630.GF5585@boogie.lpds.sztaki.hu>
References: <200910261221.23711.tfjellstrom@shaw.ca>
 <812581.75103.qm@web38808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <812581.75103.qm@web38808.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 27, 2009 at 07:32:52AM -0700, adfas asd wrote:

> Thanks.  But what I have in mind is serving the HTPC's array (with
> videos)to the storage server via iSCSI.  Hopefully the array can be
> mounted on the HTPS and still be served to the remote storage server
> by iSCSI?

No. You either mount the fs locally _or_ export it via iSCSI. You can't
do both simultaneously. If you want to access the files from both
locations, you have to use NFS or Samba (or a distributed file system,
but that's IMHO way too complicated for your setup).

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
