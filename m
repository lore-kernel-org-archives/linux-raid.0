From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Re: Weird Issue with raid 5+0
Date: Mon, 08 Mar 2010 17:14:29 -0800
Message-ID: <4B95A0F5.6090500@goop.org>
References: <31e44a111002202033m4a9dfba9yf8aef62b8b39933a@mail.gmail.com>	
	<20100221164805.5bdc2d60@notabene.brown>	
	<31e44a111002202326x407c814dsaa60e51a8a0ff049@mail.gmail.com>	
	<20100221191640.39b68b01@notabene.brown>	
	<20100308165021.6529fe6d@notabene.brown>	
	<31e44a111003080735t4ddf7c63uaa517ad6522cca67@mail.gmail.com>	
	<4B9587B2.5050700@goop.org>
	<31e44a111003081648uf0b7af2o2ece4ffbff80c749@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xensource.com>
In-Reply-To: <31e44a111003081648uf0b7af2o2ece4ffbff80c749@mail.gmail.com>
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

On 03/08/2010 04:48 PM, chris wrote:
> I will test with xenlinux 2.6.18, as far as pv_ops dom0 does this work
> with any version of the hypervisor? The current system is running 3.2
> which is pretty old so I just assumed pv_ops wouldn't be a
> possibility.
>    

I'm not sure - it's worth trying ;).  xen/next / stable-2.6.32.x 
explicitly requires 4.0 or 3.4.3, but I don't know what the earliest 
working version is for xen/master / stable-2.6.31.x.

     J
