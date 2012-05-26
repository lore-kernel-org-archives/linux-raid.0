From: David Brown <david.brown@hesbynett.no>
Subject: Re: very slow file deletion on an SSD
Date: Sat, 26 May 2012 18:00:12 +0200
Message-ID: <4FC0FE0C.8080800@hesbynett.no>
References: <4FBF60D1.80104@gmail.com> <20120525165719.GV16099@sgi.com> <20120525165938.GA13555@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120525165938.GA13555@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ben Myers <bpm@sgi.com>, Joe Landman <joe.landman@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com
List-Id: linux-raid.ids

On 25/05/12 18:59, Christoph Hellwig wrote:
> On Fri, May 25, 2012 at 11:57:19AM -0500, Ben Myers wrote:
>> There are a couple recent fixes related to discard that are probably
>> appropriate for 3.2-stable.
>
> Discard is not enabled by default.
>

You would not want to enable discard if slow deletes are an issue - 
benchmarks (on ext4) show that enabling trim makes metadata operations, 
and delete in particular, much slower.

