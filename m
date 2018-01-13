From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: Growing RAID10 with active XFS filesystem
Date: Sat, 13 Jan 2018 19:29:19 +0000
Message-ID: <5fd3434f-0d25-7c64-fa1b-9ed33f18df9c@youngman.org.uk>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia> <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk> <20180109222523.GJ16421@dastard>
 <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
 <20180111030723.GU16421@dastard> <5A58B901.7080609@youngman.org.uk>
 <20180112152538.2c4d8cd4@harpe.intellique.com>
 <5A58F5FB.7000101@youngman.org.uk>
 <09819eb5-b342-01ca-1b96-cf5395dcd2e2@hardwarefreak.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <09819eb5-b342-01ca-1b96-cf5395dcd2e2@hardwarefreak.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.org>, Emmanuel Florac <eflorac@intellique.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13/01/18 00:20, Stan Hoeppner wrote:
> It's not set in stone.  If the RAID geometry changes one can specify the 
> new geometry at mount say in fstab.  New writes to the filesystem will 
> obey the new specified geometry.

Does this then update the defaults, or do you need to specify the new 
geometry every mount? Inquiring minds need to know :-)

Cheers,
Wol
