From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: Cheap Clustered FS
Date: Thu, 13 Apr 2006 16:20:47 +0300
Message-ID: <5d96567b0604130620k1cd96714mf2f7d8e0b1d305a9@mail.gmail.com>
References: <589a24260604101424o4bbb193egcd21d639ec040322@mail.gmail.com>
	 <20060413130636.GE20839@harddisk-recovery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060413130636.GE20839@harddisk-recovery.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: Jon Miller <jonebird@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

may be lustre

On 4/13/06, Erik Mouw <erik@harddisk-recovery.com> wrote:
> On Mon, Apr 10, 2006 at 05:24:34PM -0400, Jon Miller wrote:
> > I have two machines which have redundant paths to the same shared scsi
> > disk. I've had no problem creating the multipath'ed device md0 to
> > handle my redundant pathing. But now I'd like to use a simple FS, such
> > as ext3, mounted rw on the first machine and ro on the second machine.
> > The idea is that the second machine, mounting the FS ro, would be able
> > to read any new data being written in the FS.
> > Everything has been rather easy to setup, but anything being created
> > on the FS is not seen on the other machine with the FS mounted ro.
> > That is, I can create a file on the first machine and I never see that
> > file from the second machine until I remount the FS.
> > At this point, I am actually trying to avoid GFS, OCFS, veritas
> > clustered FS options as well as NFS. If there was a simple hack, that
> > I'm missing, to enable the updates to the FS to be seen in realtime,
> > then I'd actually prefer that method.
> > Any help would be appreciated.
>
> I'm affraid the only way out is indeed GFS or OCFS. Those filesystems
> are specifically designed to be mounted by several hosts and (should)
> have caching and locking issues covered.
>
>
> Erik
>
> --
> +-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
> | Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
Raz
