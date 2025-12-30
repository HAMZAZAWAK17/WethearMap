<mxfile host="app.diagrams.net">
  <diagram name="Diagramme de classes UML">
    <mxGraphModel dx="1400" dy="1000" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1400" pageHeight="1000" math="0" shadow="0">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>

        <!-- ================= UTILISATEUR ================= -->
        <mxCell id="Utilisateur" value="Utilisateur&#xa;----------------&#xa;id : int&#xa;username : string&#xa;password : string&#xa;email : string&#xa;role : string"
                style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="120" y="40" width="200" height="160" as="geometry"/>
        </mxCell>

        <mxCell id="Etudiant" value="Etudiant&#xa;----------------&#xa;numeroInscription : string"
                style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="40" y="280" width="200" height="80" as="geometry"/>
        </mxCell>

        <mxCell id="Enseignant" value="Enseignant&#xa;----------------&#xa;departement : string&#xa;specialisation : string"
                style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="280" y="280" width="220" height="100" as="geometry"/>
        </mxCell>

        <mxCell id="Administrateur" value="Administrateur&#xa;----------------&#xa;privileges : string"
                style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="540" y="280" width="220" height="80" as="geometry"/>
        </mxCell>

        <!-- ================= STRUCTURE ================= -->
        <mxCell id="Classe" value="Classe&#xa;----------------&#xa;id : int&#xa;nom : string&#xa;niveau : string&#xa;anneeAcademique : string"
                style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="900" y="40" width="220" height="140" as="geometry"/>
        </mxCell>

        <mxCell id="Module" value="Module&#xa;----------------&#xa;id : int&#xa;nom : string"
                style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="900" y="240" width="220" height="80" as="geometry"/>
        </mxCell>

        <mxCell id="Matiere" value="Matiere&#xa;----------------&#xa;id : int&#xa;nom : string&#xa;coefficient : float"
                style="rounded=0;whiteSpace=wrap;html=1;" vertex="1" parent="1">
          <mxGeometry x="900" y="380" width="220" height="120" as="geometry"/>
        </mxCell>

        <!-- ================= CLASSES ASSOCIATIVES ================= -->
        <mxCell id="INSCRIPTION" value="&lt;&lt;association&gt;&gt;&#xa;INSCRIPTION&#xa;----------------&#xa;dateInscription : date&#xa;statut : string"
                style="rounded=1;whiteSpace=wrap;html=1;strokeDasharray=3 3;" vertex="1" parent="1">
          <mxGeometry x="500" y="500" width="240" height="120" as="geometry"/>
        </mxCell>

        <mxCell id="ENSEIGNEMENT" value="&lt;&lt;association&gt;&gt;&#xa;ENSEIGNEMENT&#xa;----------------&#xa;anneeAcademique : string&#xa;heuresParSemaine : int"
                style="rounded=1;whiteSpace=wrap;html=1;strokeDasharray=3 3;" vertex="1" parent="1">
          <mxGeometry x="600" y="680" width="260" height="120" as="geometry"/>
        </mxCell>

        <mxCell id="EVALUATION" value="&lt;&lt;association&gt;&gt;&#xa;EVALUATION&#xa;----------------&#xa;noteDS : float&#xa;noteTP : float&#xa;noteExamen : float&#xa;moyenne : float"
                style="rounded=1;whiteSpace=wrap;html=1;strokeDasharray=3 3;" vertex="1" parent="1">
          <mxGeometry x="180" y="500" width="260" height="140" as="geometry"/>
        </mxCell>

        <mxCell id="SOUMISSION" value="&lt;&lt;association&gt;&gt;&#xa;SOUMISSION&#xa;----------------&#xa;dateSoumission : date&#xa;note : float&#xa;commentaire : string"
                style="rounded=1;whiteSpace=wrap;html=1;strokeDasharray=3 3;" vertex="1" parent="1">
          <mxGeometry x="180" y="680" width="260" height="140" as="geometry"/>
        </mxCell>

        <!-- ================= RELATIONS D'HERITAGE ================= -->
        <!-- Etudiant hérite de Utilisateur -->
        <mxCell id="heritage1" value="" style="endArrow=block;endSize=16;endFill=0;html=1;rounded=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;exitX=0.5;exitY=1;exitDx=0;exitDy=0;" edge="1" parent="1" source="Etudiant" target="Utilisateur">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="140" y="240" as="sourcePoint"/>
            <mxPoint x="190" y="190" as="targetPoint"/>
          </mxGeometry>
        </mxCell>

        <!-- Enseignant hérite de Utilisateur -->
        <mxCell id="heritage2" value="" style="endArrow=block;endSize=16;endFill=0;html=1;rounded=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;exitX=0.5;exitY=1;exitDx=0;exitDy=0;" edge="1" parent="1" source="Enseignant" target="Utilisateur">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="390" y="240" as="sourcePoint"/>
            <mxPoint x="220" y="190" as="targetPoint"/>
          </mxGeometry>
        </mxCell>

        <!-- Administrateur hérite de Utilisateur -->
        <mxCell id="heritage3" value="" style="endArrow=block;endSize=16;endFill=0;html=1;rounded=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;exitX=0.5;exitY=1;exitDx=0;exitDy=0;" edge="1" parent="1" source="Administrateur" target="Utilisateur">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="650" y="240" as="sourcePoint"/>
            <mxPoint x="220" y="190" as="targetPoint"/>
          </mxGeometry>
        </mxCell>

        <!-- ================= RELATIONS DE COMPOSITION/AGREGATION ================= -->
        <!-- Classe contient Module (agrégation) -->
        <mxCell id="agg1" value="" style="endArrow=diamond;endSize=16;endFill=1;html=1;rounded=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;exitX=1;exitY=0.5;exitDx=0;exitDy=0;" edge="1" parent="1" source="Classe" target="Module">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="1120" y="80" as="sourcePoint"/>
            <mxPoint x="900" y="280" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="1120" y="80"/>
              <mxPoint x="1120" y="280"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="card1" value="1" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="1130" y="150" width="30" height="30" as="geometry"/>
        </mxCell>
        <mxCell id="card2" value="0..*" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="1130" y="280" width="30" height="30" as="geometry"/>
        </mxCell>

        <!-- Module contient Matiere (agrégation) -->
        <mxCell id="agg2" value="" style="endArrow=diamond;endSize=16;endFill=1;html=1;rounded=0;entryX=0;entryY=0.5;entryDx=0;entryDy=0;exitX=1;exitY=0.5;exitDx=0;exitDy=0;" edge="1" parent="1" source="Module" target="Matiere">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="1120" y="280" as="sourcePoint"/>
            <mxPoint x="900" y="440" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="1120" y="320"/>
              <mxPoint x="1120" y="440"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="card3" value="1" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="1130" y="320" width="30" height="30" as="geometry"/>
        </mxCell>
        <mxCell id="card4" value="0..*" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="1130" y="440" width="30" height="30" as="geometry"/>
        </mxCell>

        <!-- ================= ASSOCIATIONS AVEC CLASSES ASSOCIATIVES ================= -->
        <!-- Etudiant <---> Classe via INSCRIPTION -->
        <mxCell id="assoc1" value="" style="endArrow=none;html=1;rounded=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;exitX=0.5;exitY=1;exitDx=0;exitDy=0;" edge="1" parent="1" source="Etudiant" target="INSCRIPTION">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="140" y="360" as="sourcePoint"/>
            <mxPoint x="620" y="500" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="140" y="500"/>
              <mxPoint x="620" y="500"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="card5" value="0..*" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="50" y="500" width="40" height="20" as="geometry"/>
        </mxCell>

        <mxCell id="assoc2" value="" style="endArrow=none;html=1;rounded=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;exitX=0.5;exitY=0;exitDx=0;exitDy=0;" edge="1" parent="1" source="INSCRIPTION" target="Classe">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="620" y="620" as="sourcePoint"/>
            <mxPoint x="1010" y="40" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="620" y="620"/>
              <mxPoint x="1010" y="620"/>
              <mxPoint x="1010" y="40"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="card6" value="0..*" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="1020" y="620" width="40" height="20" as="geometry"/>
        </mxCell>

        <!-- Enseignant <---> Module via ENSEIGNEMENT -->
        <mxCell id="assoc3" value="" style="endArrow=none;html=1;rounded=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;exitX=0.5;exitY=1;exitDx=0;exitDy=0;" edge="1" parent="1" source="Enseignant" target="ENSEIGNEMENT">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="390" y="380" as="sourcePoint"/>
            <mxPoint x="730" y="680" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="390" y="680"/>
              <mxPoint x="730" y="680"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="card7" value="0..*" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="300" y="680" width="40" height="20" as="geometry"/>
        </mxCell>

        <mxCell id="assoc4" value="" style="endArrow=none;html=1;rounded=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;exitX=0.5;exitY=0;exitDx=0;exitDy=0;" edge="1" parent="1" source="ENSEIGNEMENT" target="Module">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="730" y="800" as="sourcePoint"/>
            <mxPoint x="1010" y="240" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="730" y="800"/>
              <mxPoint x="1010" y="800"/>
              <mxPoint x="1010" y="240"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="card8" value="0..*" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="1020" y="800" width="40" height="20" as="geometry"/>
        </mxCell>

        <!-- Etudiant <---> Matiere via EVALUATION -->
        <mxCell id="assoc5" value="" style="endArrow=none;html=1;rounded=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;exitX=0.5;exitY=1;exitDx=0;exitDy=0;" edge="1" parent="1" source="Etudiant" target="EVALUATION">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="140" y="360" as="sourcePoint"/>
            <mxPoint x="310" y="500" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="140" y="500"/>
              <mxPoint x="310" y="500"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="card9" value="0..*" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="50" y="500" width="40" height="20" as="geometry"/>
        </mxCell>

        <mxCell id="assoc6" value="" style="endArrow=none;html=1;rounded=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;exitX=0.5;exitY=0;exitDx=0;exitDy=0;" edge="1" parent="1" source="EVALUATION" target="Matiere">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="310" y="640" as="sourcePoint"/>
            <mxPoint x="1010" y="380" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="310" y="640"/>
              <mxPoint x="1010" y="640"/>
              <mxPoint x="1010" y="380"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="card10" value="0..*" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="1020" y="640" width="40" height="20" as="geometry"/>
        </mxCell>

        <!-- Etudiant <---> Matiere via SOUMISSION -->
        <mxCell id="assoc7" value="" style="endArrow=none;html=1;rounded=0;entryX=0.5;entryY=0;entryDx=0;entryDy=0;exitX=0.5;exitY=1;exitDx=0;exitDy=0;" edge="1" parent="1" source="Etudiant" target="SOUMISSION">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="140" y="360" as="sourcePoint"/>
            <mxPoint x="310" y="680" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="140" y="680"/>
              <mxPoint x="310" y="680"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="card11" value="0..*" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="50" y="680" width="40" height="20" as="geometry"/>
        </mxCell>

        <mxCell id="assoc8" value="" style="endArrow=none;html=1;rounded=0;entryX=0.5;entryY=1;entryDx=0;entryDy=0;exitX=0.5;exitY=0;exitDx=0;exitDy=0;" edge="1" parent="1" source="SOUMISSION" target="Matiere">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="310" y="820" as="sourcePoint"/>
            <mxPoint x="1010" y="380" as="targetPoint"/>
            <Array as="points">
              <mxPoint x="310" y="820"/>
              <mxPoint x="1010" y="820"/>
              <mxPoint x="1010" y="380"/>
            </Array>
          </mxGeometry>
        </mxCell>
        <mxCell id="card12" value="0..*" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;" vertex="1" parent="1">
          <mxGeometry x="1020" y="820" width="40" height="20" as="geometry"/>
        </mxCell>

      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
