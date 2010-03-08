From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Re: Weird Issue with raid 5+0
Date: Mon, 08 Mar 2010 15:26:42 -0800
Message-ID: <4B9587B2.5050700@goop.org>
References: <31e44a111002202033m4a9dfba9yf8aef62b8b39933a@mail.gmail.com>	<20100221164805.5bdc2d60@notabene.brown>	<31e44a111002202326x407c814dsaa60e51a8a0ff049@mail.gmail.com>	<20100221191640.39b68b01@notabene.brown>	<20100308165021.6529fe6d@notabene.brown>
	<31e44a111003080735t4ddf7c63uaa517ad6522cca67@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <31e44a111003080735t4ddf7c63uaa517ad6522cca67@mail.gmail.com>
List-Unsubscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
To: chris <tknchris@gmail.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, Xen-Devel List <xen-devel@lists.xensource.com>
List-Id: linux-raid.ids

On 03/08/2010 07:35 AM, chris wrote:
> I forwarding this to xen-devel because it appears to be a bug in dom0 kernel.
>
> I recently experienced a strange issue with software raid1+0 under Xen
> on a new machine. I was getting corruption in my guest volumes and
> tons of kernel messages such as:
>
> [305044.571962] raid0_make_request bug: can't convert block across
> chunks or bigger than 64k 14147455 4
>
> The full thread is located at http://marc.info/?t=126672694700001&r=1&w=2
> Detailed output at http://pastebin.com/f6a52db74
>
> It appears after speaking with the linux-raid mailing list that this
> is due a bug which has been fixed but the fix is not included in the
> dom0 kernel. I'm not sure what sources kernel 2.6.26-2-xen-amd64 is
> based on, but since xenlinux is still at 2.6.18 I was assuming that
> this bug would still exist.
>    

There are a number of possible dom0 kernel in use.  The xen.org 
2.6.18-xen tree is still maintained on a bugfix basis.  Are you seeing 
the problem with 2.6.18-xen?

I don't know what 2.6.26-2-xen-amd64 is, but I'm guessing from the name 
it is a Debian kernel.  I don't know what its provenance is, but it is 
not a xen.org supported kernel; if a fix is needed you should file a bug 
against your distro.

Modern Xen kernels are based on 2.6.31.x and 2.6.32.x.  See 
http://wiki.xensource.com/xenwiki/XenParavirtOps and 
http://wiki.xensource.com/xenwiki/XenDom0Kernels for more details.

     J
