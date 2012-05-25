From: Christoph Hellwig <hch@infradead.org>
Subject: Re: very slow file deletion on an SSD
Date: Fri, 25 May 2012 12:59:38 -0400
Message-ID: <20120525165938.GA13555@infradead.org>
References: <4FBF60D1.80104@gmail.com>
 <20120525165719.GV16099@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120525165719.GV16099@sgi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Myers <bpm@sgi.com>
Cc: Joe Landman <joe.landman@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Fri, May 25, 2012 at 11:57:19AM -0500, Ben Myers wrote:
> There are a couple recent fixes related to discard that are probably
> appropriate for 3.2-stable.

Discard is not enabled by default.

