From: roger zhou <zzhou-IBi9RG/b67k@public.gmane.org>
Subject: Re: clustered MD - beyond RAID1
Date: Fri, 25 Dec 2015 16:47:14 +0800
Message-ID: <567D0292.6040606@suse.com>
References: <56742652.5040304@nasa.gov>
	<87si2w66tm.fsf@notabene.neil.brown.name> <567850C4.30108@bnl.gov>
	<87bn9j4jhr.fsf@notabene.neil.brown.name> <56786EA4.2020209@bnl.gov>
	<8737uv4fz6.fsf@notabene.neil.brown.name> <5678A2B9.6070008@bnl.gov>
	<5678AC55.7070606@nasa.gov> <5678B693.40907@bnl.gov>
Reply-To: Cluster Labs - All topics related to open-source clustering
	welcomed <users-iJOQKD3IPJ/s2ve5o0e2fw@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3687497246831613928=="
Return-path: <users-bounces-iJOQKD3IPJ/s2ve5o0e2fw@public.gmane.org>
In-Reply-To: <5678B693.40907-IGkKxAqZmp0@public.gmane.org>
List-Unsubscribe: <http://clusterlabs.org/mailman/options/users>,
	<mailto:users-request-iJOQKD3IPJ/s2ve5o0e2fw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://clusterlabs.org/pipermail/users/>
List-Post: <mailto:users-iJOQKD3IPJ/s2ve5o0e2fw@public.gmane.org>
List-Help: <mailto:users-request-iJOQKD3IPJ/s2ve5o0e2fw@public.gmane.org?subject=help>
List-Subscribe: <http://clusterlabs.org/mailman/listinfo/users>,
	<mailto:users-request-iJOQKD3IPJ/s2ve5o0e2fw@public.gmane.org?subject=subscribe>
Errors-To: users-bounces-iJOQKD3IPJ/s2ve5o0e2fw@public.gmane.org
To: Tejas Rao <raot-IGkKxAqZmp0@public.gmane.org>, Aaron Knister <aaron.s.knister-NSQ8wuThN14@public.gmane.org>
Cc: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Scott Sinno <scott.sinno-NSQ8wuThN14@public.gmane.org>, users-iJOQKD3IPJ/s2ve5o0e2fw@public.gmane.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--===============3687497246831613928==
Content-Type: multipart/alternative;
 boundary="------------070607010406080709010009"

This is a multi-part message in MIME format.
--------------070607010406080709010009
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit


On 12/22/2015 10:33 AM, Tejas Rao wrote:
> On 12/21/2015 20:50, Aaron Knister wrote:
>
[...]
>>
>> I'm curious now, Redhat doesn't support SW raid failover? I did some
>> googling and found this:
>>
>> https://access.redhat.com/solutions/231643
>>
>> While I can't read the solution I have to figure that they're now
>> supporting that. I might actually explore that for this project.
> https://access.redhat.com/solutions/410203
> This article states that md raid is not supported in RHEL6/7 under any 
> circumstances, including active/passive modes.

OCFS2 or GFS2(same for GPFS, as the shared filesystem) over a shared 
storage is a typical Cluster configuration for Linux High Availability. 
Where, Clustered LVM (cLVM) is supported by both SUSE and Redhat to do 
mirroring to protect the data. However, the performance loss is very big 
and make people not so happy about this clustered mirror solution. This 
is where the motivation for clustered MD solution comes from.

With clustered md, this new solution could provide nearly the same 
performance as the native raid1. You may have interest to validate this 
from your lab with your configuration;)

Cheers,
Roger




--------------070607010406080709010009
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta content="text/html; charset=windows-1252"
      http-equiv="Content-Type">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <br>
    <div class="moz-cite-prefix">On 12/22/2015 10:33 AM, Tejas Rao
      wrote:<br>
    </div>
    <blockquote cite="mid:5678B693.40907-IGkKxAqZmp0@public.gmane.org" type="cite">On
      12/21/2015 20:50, Aaron Knister wrote:
      <br>
      <br>
    </blockquote>
    [...]<br>
    <blockquote cite="mid:5678B693.40907-IGkKxAqZmp0@public.gmane.org" type="cite">
      <blockquote type="cite">
        <br>
        I'm curious now, Redhat doesn't support SW raid failover? I did
        some
        <br>
        googling and found this:
        <br>
        <br>
        <a class="moz-txt-link-freetext" href="https://access.redhat.com/solutions/231643">https://access.redhat.com/solutions/231643</a>
        <br>
        <br>
        While I can't read the solution I have to figure that they're
        now
        <br>
        supporting that. I might actually explore that for this project.
        <br>
      </blockquote>
      <a class="moz-txt-link-freetext" href="https://access.redhat.com/solutions/410203">https://access.redhat.com/solutions/410203</a>
      <br>
      This article states that md raid is not supported in RHEL6/7 under
      any circumstances, including active/passive modes.
      <br>
    </blockquote>
    <br>
    OCFS2 or GFS2(same for GPFS, as the shared filesystem) over a shared
    storage is a typical Cluster configuration for Linux High
    Availability. Where, Clustered LVM (cLVM) is supported by both SUSE
    and Redhat to do mirroring to protect the data. However, the
    performance loss is very big and make people not so happy about this
    clustered mirror solution. This is where the motivation for
    clustered MD solution comes from. <br>
    <br>
    With clustered md, this new solution could provide nearly the same
    performance as the native raid1. You may have interest to validate
    this from your lab with your configuration;)<br>
    <br>
    Cheers,<br>
    Roger<br>
    <br>
    <meta http-equiv="content-type" content="text/html;
      charset=windows-1252">
    <br>
    <br>
  </body>
</html>

--------------070607010406080709010009--


--===============3687497246831613928==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3687497246831613928==--
