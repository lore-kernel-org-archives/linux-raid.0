From: Derek Vadala <derek@cynicism.com>
Subject: RE: Growing an Array?
Date: Wed, 6 Nov 2002 12:35:53 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021106173553.163A03B807@jaded.cynicism.com>
References: <A506359028CAD21191C10008C75D895C040B8850@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A506359028CAD21191C10008C75D895C040B8850@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
To: Huntress Gary B NPRI <HuntressGB@Npt.NUWC.Navy.Mil>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 6 Nov 2002, Huntress Gary B NPRI wrote:

> Actually I meant an array of six 73GB drives switching to six 180GB
> drives, but thats conceptually the same.

I think that your best bet is to bring the new array online and copy the
data over using traditional methods. That's going to be the fastest way to
get the new array online. The other methods (backup and restore,
raidreconf) are either slower or don't apply specifically to this case.

--
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

