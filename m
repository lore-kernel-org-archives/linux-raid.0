From: <tao.peng-mb1K0bWo544@public.gmane.org>
Subject: RE: Linux 3.1-rc1 (nfs/pnfs and drivers/md)
Date: Thu, 11 Aug 2011 02:21:17 -0400
Message-ID: <F19688880B763E40B28B2B462677FBF805BF0EACC4@MX09A.corp.emc.com>
References: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com>
 <20110810122304.96b8be67.rdunlap@xenotime.net>
 <CA+a=Yy5izxiyvW5eYiWuute9E1vXwNTj4frdzNeEwsLDrszesg@mail.gmail.com>
 <20110810175829.a834d80f.rdunlap@xenotime.net>
 <CA+55aFzcSLrhkexEn=J7BN8F3P3Vy+EAjwgGwMQPdeoYoQG+Bw@mail.gmail.com>
 <F19688880B763E40B28B2B462677FBF805BF0EAC8A@MX09A.corp.emc.com>
 <20110811060633.GA11654@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110811060633.GA11654-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org, bergwolf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org]
> Sent: Thursday, August 11, 2011 2:07 PM
> To: Peng, Tao
> Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org; rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org; bergwolf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org; linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Linux 3.1-rc1 (nfs/pnfs and drivers/md)
> 
> Note that the object layout also effectively needs the block layer.
> 
That is taken care of by PNFS_OBJLAYOUT depending on SCSI_OSD_ULD.

The dependency chain for PNFS_OBJLAYOUT on BLOCK is:
PNFS_OBJLAYOUT-> SCSI_OSD_ULD -> SCSI_OSD_INITIATOR -> SCSI-> BLOCK

With the patch, if CONFIG_BLOCK is not set, pnfs file layout can still be built.

Thanks,
Tao

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
