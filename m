From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH]  DM RAID:  Ensure the bitmap region_size is a power of 2
Date: Wed, 12 Dec 2012 16:10:18 +0000
Message-ID: <20121212161018.GF12788@agk.fab.redhat.com>
References: <1355261825.26828.6.camel@f16> <1355324012.26828.9.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1355324012.26828.9.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, agk@redhat.com
List-Id: linux-raid.ids

On Wed, Dec 12, 2012 at 08:53:32AM -0600, Jon Brassow wrote:
> This is probably a better way to do it...
 
Indeed.  I'll pick this one up.

> DM RAID:  Ensure the bitmap region_size is a power of 2
> 
> If the user does not supply a region_size, a reasonable size is computed
> automatically.  However, region_size needs to be a power of 2 and the
> code was not properly ensuring that.
 
And this is just a cleanup patch: to provide a controlled error message
here, rather than triggering a controlled error inside the md code
later.

Alasdair

