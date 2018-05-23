From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 6/6] Drop flex_arrays
Date: Wed, 23 May 2018 18:06:26 -0400
Message-ID: <20180523220626.GA23040@kmo-pixel>
References: <20180523011821.12165-1-kent.overstreet@gmail.com>
	<20180523011821.12165-6-kent.overstreet@gmail.com>
	<0fb1b28b-12da-5d2b-2308-283af9fe6ae4@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0fb1b28b-12da-5d2b-2308-283af9fe6ae4-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://mail.openvswitch.org/mailman/options/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.openvswitch.org/pipermail/ovs-dev/>
List-Post: <mailto:ovs-dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Help: <mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.openvswitch.org/mailman/listinfo/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=subscribe>
Sender: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
Errors-To: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-raid.ids

On Wed, May 23, 2018 at 10:24:18AM -0700, Dave Hansen wrote:
> Thanks for the heads-up, Matthew!

Sorry, I was just using scripts/get_maintainers, forgot to check the actual file
for the original author :)

> On 05/22/2018 06:18 PM, Kent Overstreet wrote:
> > All existing users have been converted to generic radix trees
> 
> Well, flex_arrays had a good run, and the new radix trees do look quite
> a bit nicer.
> 
> Feel free to add my ack.

Cool, thanks!
