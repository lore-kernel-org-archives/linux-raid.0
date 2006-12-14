From: Al Boldi <a1426z-u1xxEuL7cY4AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ANNOUNCE] RAIF: Redundant Array of Independent
	Filesystems
Date: Thu, 14 Dec 2006 14:12:30 +0300
Message-ID: <200612141412.30686.a1426z@gawab.com>
References: <Pine.GSO.4.53.0612122217360.22195@compserv1>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Return-path: <unionfs-bounces-K1gu+h1r3dsZjdeEBZXbMidm6ipF23ct@public.gmane.org>
In-Reply-To: <Pine.GSO.4.53.0612122217360.22195@compserv1>
Content-Disposition: inline
List-Unsubscribe: <http://www.fsl.cs.sunysb.edu/mailman/listinfo/unionfs>,
	<mailto:unionfs-request-w3Aa1c639fCwRS80dfYGFoIJIQD0bWaD@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.fsl.cs.sunysb.edu/pipermail/unionfs>
List-Post: <mailto:unionfs-w3Aa1c639fCwRS80dfYGFoIJIQD0bWaD@public.gmane.org>
List-Help: <mailto:unionfs-request-w3Aa1c639fCwRS80dfYGFoIJIQD0bWaD@public.gmane.org?subject=help>
List-Subscribe: <http://www.fsl.cs.sunysb.edu/mailman/listinfo/unionfs>,
	<mailto:unionfs-request-w3Aa1c639fCwRS80dfYGFoIJIQD0bWaD@public.gmane.org?subject=subscribe>
Sender: unionfs-bounces-2jbElX+0AsP5NRxSJurNR4dd74u8MsAO@public.gmane.org
Errors-To: unionfs-bounces-2jbElX+0AsP5NRxSJurNR4dd74u8MsAO@public.gmane.org
To: Nikolai Joukov <kolya-EX0cT3Az47bauI2f2gSDlQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fistgen-2jbElX+0AsP5NRxSJurNR4dd74u8MsAO@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, unionfs-2jbElX+0AsP5NRxSJurNR4dd74u8MsAO@public.gmane.org
List-Id: linux-raid.ids

Nikolai Joukov wrote:
> We started the project in April 2004.  Right now I am using it as my
> /home/kolya file system at home.  We believe that at this stage RAIF is
> mature enough for others to try it out.  The code is available at:
>
> 	<ftp://ftp.fsl.cs.sunysb.edu/pub/raif/>
>
> The code requires no kernel patches and compiles for a wide range of
> kernels as a module.  The latest kernel we used it for is 2.6.13 and we
> are in the process of porting it to 2.6.19.
>
> We will be happy to hear your back.

When removing a file from the underlying branch, the oops below happens.
Wouldn't it be possible to just fail the branch instead of oopsing?


Thanks!

--
Al

====================
Registering raif version $Id: main.c,v 1.51 2006/12/13 17:00:21 kolya Exp $
dtohd_index(dentry, bindex)->d_inode NULL for [x, 0x3]
ASSERTION FAILED dtohd_index(dentry, bindex)->d_inode (null) at 
/tmp/sw/raif/main.c:54 (raif_interpose_debug) called by 
/tmp/sw/raif/inode.c:162 (raif_lookup_backend)
Unable to handle kernel NULL pointer dereference at virtual address 00000000
 printing eip:
df9fd2a2
*pde = 00000000
Oops: 0002 [#1]
Modules linked in: raif
CPU:    0
EIP:    0060:[<df9fd2a2>]    Not tainted VLI
EFLAGS: 00010286   (2.6.13) 
EIP is at raif_interpose_debug+0x6ba/0x738 [raif]
eax: 000000ad   ebx: dfa01a29   ecx: ddb13d94   edx: dfa02980
esi: 000000a2   edi: 00000001   ebp: 00000002   esp: ddb13db4
ds: 007b   es: 007b   ss: 0068
Process mc (pid: 662, threadinfo=ddb12000 task=ddf10020)
Stack: dd20a62c 00000000 c014d1d8 ddb13dd8 dd20a7a1 00000000 00000001 
dd1a4000 
       dd20a73c 00000002 dd20a73c 00000001 00000000 df9f9332 dfa0212a 
000000a2 
       dfa01a29 00000001 00000000 00000002 00000000 00000001 dd221de4 
458073a1 
Call Trace:
 [<c014d1d8>] __lookup_hash+0x70/0x94
 [<df9f9332>] raif_lookup_backend+0x232/0x310 [raif]
 [<c014becc>] real_lookup+0x8c/0xa8
 [<c014c123>] do_lookup+0x6b/0x78
 [<c014c78b>] __link_path_walk+0x65b/0xcd4
 [<df9f53c4>] raif_filldir+0x0/0x134 [raif]
 [<c014ce49>] link_path_walk+0x45/0xd4
 [<df9ff0dc>] free_rdstate+0x4c/0xb4 [raif]
 [<c01160e8>] current_fs_time+0x44/0x5c
 [<c014d0d8>] path_lookup+0x70/0x100
 [<c014d285>] __user_walk+0x21/0x38
 [<c0148a3d>] vfs_lstat+0x11/0x3c
 [<df9ff0dc>] free_rdstate+0x4c/0xb4 [raif]
 [<c01160e8>] current_fs_time+0x44/0x5c
 [<c0148ff7>] sys_lstat64+0xf/0x28
 [<c01500e3>] vfs_readdir+0x67/0x6c
 [<c0150777>] sys_getdents64+0xb3/0xc4
 [<c01029bd>] syscall_call+0x7/0xb
Code: 6a 36 3d 5a 5a 5a 5a 68 2a 22 a0 df ba 52 22 a0 df 74 05 ba 5d 22 a0 df 
52 68 40 29 a0 df 68 80 29 a0 df e8 15 52 71 e0 83 c4 24 <c6> 05 00 00 00 00 
00 e9 ad f9 ff ff 89 f6 ff 72 08 8b 54 24 24 
