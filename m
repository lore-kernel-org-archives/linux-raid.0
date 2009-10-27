From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Is My Data DESTROYED?!
Date: Tue, 27 Oct 2009 07:40:52 -0700 (PDT)
Message-ID: <235564.59062.qm@web38801.mail.mud.yahoo.com>
References: <20091027143630.GF5585@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091027143630.GF5585@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Tue, 10/27/09, Gabor Gombas <gombasg@sztaki.hu> wrote:
> > Thanks.  But what I have in mind is serving the
> HTPC's array (with
> > videos)to the storage server via iSCSI. 
> Hopefully the array can be
> > mounted on the HTPS and still be served to the remote
> storage server
> > by iSCSI?
> 
> No. You either mount the fs locally _or_ export it via
> iSCSI. You can't
> do both simultaneously. If you want to access the files
> from both
> locations, you have to use NFS or Samba (or a distributed
> file system,
> but that's IMHO way too complicated for your setup).

Oh no.  Well I don't see the point of iSCSI then.

I wouldn't even consider NFS or Samba because they are ancient bloatware.  I gather from a prior post that rsync has a remote ssh function.  If that's not the case then I guess it has to be sshfs.



      
