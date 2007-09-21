From: "Chris Fanning" <christopher.fanning@gmail.com>
Subject: syncing remote homes.
Date: Fri, 21 Sep 2007 15:26:12 +0200
Message-ID: <215ff4410709210626j604d2b9cm57d6c30987f767d0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I hope this isn't a complete off-topic question (or a stupid one either).

We want to setup two desktop servers at two different office branches.
users will open sessions via nx.
We dont' have are problem keeping the server instalations in sync and,
in case of disaster at one office, we can route sessions to the
remaining server at the other office with DNS (that's the plan
anayway).

But we're not sure about how to keep the homes in sync between the two
servers. We've thought about nightly rsync but what else could be
done?
One suggestion was to use md with one local disc and another remote
disc via iSCSI. But I don't think that would work because our network
connection is not fast. Is that correct?

Any advise please?

Thanks.
Chris.
