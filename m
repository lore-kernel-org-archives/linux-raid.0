From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: mdadm: different component-count in superblocks prevents assembly
Date: Mon, 3 Sep 2007 22:42:55 +0200
Message-ID: <fbhrkf$kpd$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Again :)

Having a component device with slightly different superblock
characteristics in the system prevents mdadm from assembling arrays.
For example:
	mdadm --fail /dev/mdx /dev/xdx
	mdadm -G -n y-1 /dev/mdx
would lead to a non-assemble-able /dev/mdx as long as /dev/xdx remains
in the system and thus probably leads to an unbootable system should
/dev/mdx be /.

Wouldn't it make sense to weight other superblock parameters like the
event counter a little higher, i.e. under all unique-id'ed devices
consider first only those with the highest equal event count and only
afterwards compare the rest of the superblocks (and then fail, if they
don't match, of course)?


regards
   Mario
-- 
Goethe war nicht gerne Minister. Er beschaeftigte sich lieber geistig.
                                            -- Lukasburger Stilblueten

