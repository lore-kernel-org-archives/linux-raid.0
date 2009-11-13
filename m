From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Fri, 13 Nov 2009 16:54:41 -0700
Message-ID: <e9c3a7c20911131554w28075d39mbc8bebc17a4ef260@mail.gmail.com>
References: <19187.50708.551325.297625@notabene.brown>
	 <4AF829B2.5090001@redhat.com>
	 <423765b7af1be77f0a40dcbbb1f65c4b.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <423765b7af1be77f0a40dcbbb1f65c4b.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil F Brown <nfbrown@novell.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 9, 2009 at 1:22 PM, Neil F Brown <nfbrown@novell.com> wrote:
> I'm certainly happy with increasing the chunksize to 512K.

Probably good for reads, but it makes it harder for the code to
collect full stripe writes.  I guess I should get some data to back
that up one of these days...

--
Dan
