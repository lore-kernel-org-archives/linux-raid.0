From: David Rientjes <rientjes@google.com>
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
Date: Mon, 23 Aug 2010 13:40:11 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008231339300.20535@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com> <alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com> <20100823122606.47524cef.akpm@linux-foundation.org> <alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
 <20100823130109.6da43a58.akpm@linux-foundation.org> <AANLkTikpTZfUE-XFCXJV6FdZy0ZTWeoPLF_qErvvjGOy@mail.gmail.com> <alpine.DEB.2.00.1008231310100.17716@chino.kir.corp.google.com> <AANLkTi=HxY6w2iJme3qW_J_sbXedu7JSSECBEFPM1d_c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=HxY6w2iJme3qW_J_sbXedu7JSSECBEFPM1d_c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pekka Enberg <penberg@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 23 Aug 2010, Pekka Enberg wrote:

> My point is that I don't think Andrew's helper will change all that
> much. Fixing the actual callers is the hard part and I don't see your
> patches helping that either. Hiding the looping in filesystem code is
> only going to make problematic callers harder to find (e.g
> kmem_alloc() in XFS code).
> 

Nothing is getting hidden in the callers here, all of the patches in this 
series are using __GFP_NOFAIL unnecessarily.
