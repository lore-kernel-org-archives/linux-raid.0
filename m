From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: Growing RAID10 with active XFS filesystem
Date: Fri, 12 Jan 2018 19:35:18 +0000
Message-ID: <8a8f7b91-80b5-3600-a82b-b55691d0ac6b@youngman.org.uk>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
 <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
 <20180111030723.GU16421@dastard> <5A58B901.7080609@youngman.org.uk>
 <20180112152538.2c4d8cd4@harpe.intellique.com>
 <5A58F5FB.7000101@youngman.org.uk>
 <20180112193710.1369f4ad@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180112193710.1369f4ad@harpe.intellique.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/01/18 18:37, Emmanuel Florac wrote:
>> Or could it simply switch over to optimising for the new geometry,
>> accept the fact that the reshape will have caused hotspots, and every
>> time it rewrites (meta)data, it adjusts it to the new geometry to
>> reduce/remove hotspots over time?
>>
> I suppose it's doable but not sufficiently a prominent use case to
> bother much.

Stick it on the "nice to have when somebody gets round to it" list :-) 
But it at least should get put on the list ...

I'll get round to writing all this up soon, so the wiki will try and 
persuade people that resizing arrays is not actually the brightest of 
ideas.

The trouble is lack of people talking to each other and thinking that 
they can rely on the "do one job and do it well". Except of course that 
you can't square a circle ... :-)

But this really is stuff that needs to be on the wiki, and it's stuff 
the MD and filesystem people don't talk about with each other, I expect :-(

Cheers,
Wol
