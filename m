From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 06/13] async_tx: add support for asynchronous GF
	multiplication
Date: Sat, 21 Mar 2009 15:00:10 -0700
Message-ID: <e9c3a7c20903211500j3f1575e7o2ad9fb5969a2bdd@mail.gmail.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
	 <20090318192046.20375.89854.stgit@dwillia2-linux.ch.intel.com>
	 <49C26D91.10804@intel.com> <49C5486D.9020103@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49C5486D.9020103@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ilya Yanok <yanok@emcraft.com>
Cc: "H. Peter Anvin" <h.peter.anvin@intel.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, maciej.sosnowski@intel.com, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

On Sat, Mar 21, 2009 at 1:05 PM, Ilya Yanok <yanok@emcraft.com> wrote:
> Have you ever tested this code path?

Not this path, not yet.  Which is exactly why I am holding back the md
pieces.  We can collaborate on testing and stabilizing the api for a
kernel cycle before turning on the raid6 conversion.

--
Dan
